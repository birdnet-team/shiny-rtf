#' detections_table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import reactable
#' @import httr2
#' @import dplyr lubridate
#' @import av
#' @import shinyWidgets reactable
mod_detections_table_ui <- function(id) {
  ns <- NS(id)
  tagList(fluidRow(
    column(
      7,
      shinyWidgets::panel(
        extra = reactableOutput(ns("table")),
        heading = "Detections"
      )
    ),
    column(
      5,
      conditionalPanel(
        ns = ns,
        condition = "!output.show_spec_panel",
        shinyWidgets::panel(
          heading = "Spectrogram",
          div(p("No media selected or available"),
            style = "margin-top: 5rem; margin-bottom: 5rem; text-align: center; font-size: larger;color: #b1b1b1;"
          )
        )
      ),
      conditionalPanel(
        ns = ns,
        condition = "output.show_spec_panel",
        shinyWidgets::panel(
          heading = "Spectrogram",
          fluidRow(plotOutput(ns("spectrogram"))),
          fluidRow(uiOutput(ns("audio_controls"))),
          fluidRow(
            column(
              4,
              sliderInput(
                ns("max_freq"),
                label = "max. frequency (kHz)",
                ticks = FALSE,
                value = 24,
                max = 24,
                min = 1,
                step = 0.5
              )
            ),
            column(
              4,
              selectInput(
                inputId = ns("fft_window_length"),
                label = "window length (FFT)",
                choices = c("512", "1024", "2048"),
                multiple = FALSE,
                selectize = TRUE,
                selected = "1024"
              )
            ),
            column(
              4,
              sliderInput(
                ns("fft_overlap"),
                label = "overlap (FFT)",
                ticks = FALSE,
                value = 0.75,
                min = 0.60,
                max = 0.98,
                step = 0.01
              )
            )
          ),
          tags$hr(),
          fluidRow(
            column(
              4,
              selectizeInput(
                ns("select_new_species_code"),
                "New species",
                choices = list(
                  "birds" = setNames(birdnames$code, birdnames$common) |> (\(x) x[order(names(x))])(),
                  "other" = setNames(other_categories$code, other_categories$common)
                )
              )
            ),
            column(
              4,
              actionButton(ns("confirm_species"), "save", style = "margin-top: 32px; padding-top: 3px; padding-bottom: 5px;")
            )
          )
        )
      )
    )
  ))
}

#' detections_table Server Functions
#'
#' @param id Internal parameter for {shiny}
#' @param detections reactive
#'
#' @noRd
mod_detections_table_server <- function(id, data, url) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns


    # Prepare Data Objects --------------------------------------------------------------------------------------------
    # reactiveValues when data needs to be changed/overwritten
    # reactives when its just to retrieve values without modifying the object

    table <- reactiveValues(
      data = NULL,
      selected_recording = NULL,
      init = NULL
    )

    # table data
    observe({
      req(data$detections)
      table$data <-
        data$detections %>%
        mutate(datetime_precise = datetime + seconds(start)) %>%
        mutate(
          datetime_precise = strftime(datetime_precise, "%F %T", tz = lubridate::tz(datetime)),
          sound_play = paste0(
            "https://reco.birdnet.tucmi.de/reco/det/",
            uid,
            "/audio"
          )
        ) %>%
        dplyr::relocate(common, .after = recorder_id)
    }) |> bindEvent(data$detections)


    # Get the table state and the selected row
    table_state <-
      reactive(getReactableState("table", session = session))
    selected_row_nr <-
      reactive(getReactableState("table", "selected", session = session))

    observe({
      table$selected_recording <- table$data |> slice(selected_row_nr())
    }) |> bindEvent(selected_row_nr())


    # Debounce Input --------------------------------------------------------------------------------------------------
    input_fft_overlap <- reactive({
      input$fft_overlap
    }) |> debounce(200)

    input_max_freq <- reactive({
      input$max_freq
    }) |> debounce(200)


    # URL and FFT data ------------------------------------------------------------------------------------------------
    audio_selected_detection <- reactiveValues(
      url = NULL,
      fft_data = NULL
    )

    # url pointing to the audio file of the detection that is selected in the table
    selected_audio_url <- reactive({
      req(table$data)
      table$data |>
        slice(selected_row_nr()) |>
        pull("sound_play")
    })

    # set condition to show spectrogram panel
    output$show_spec_panel <- reactive({
      isTruthy(selected_audio_url())
    })
    outputOptions(output, "show_spec_panel", suspendWhenHidden = FALSE)

    # download audio
    audio_file_path <- reactive({
      req(selected_audio_url())
      destfile <- tempfile(fileext = ".ogg")
      download.file(selected_audio_url(), destfile, mode = "wb")

      destfile
    }) |>
      bindCache(selected_audio_url())

    # load fft data when new detecions gets selected
    fft_data <- reactive({
      req(audio_file_path())
      av::read_audio_fft(
        audio_file_path(),
        window = av::hanning(input$fft_window_length),
        overlap = input_fft_overlap()
      )
    })

    # update input$max_freq to half the sample rate
    observe({
      spec_sr <- attr(fft_data(), "sample_rate") / 1000 / 2
      updateNumericInput(
        session = session,
        inputId = "max_freq",
        value = spec_sr,
        max = spec_sr
      )
    }) |> bindEvent(fft_data(), once = TRUE)

    # render spectrogram
    output$spectrogram <- renderPlot({
      req(fft_data())
      plot_av_fft(fft_data(), kHz = TRUE, max.freq = input_max_freq())
    })

    # render soundbar / audio controls to play the selected file
    output$audio_controls <- renderUI({
      # play directly via url
      div(
        tags$audio(
          src = selected_audio_url(),
          type = "audio/ogg",
          controls = NA
        ),
        style = "margin-top: 10px; margin-bottom: 10px"
      )
      # HTML(paste0('<audio controls><source src="', selected_audio_url(), '" type="audio/wav"></audio>'))
    }) |>
      bindCache(audio_file_path())


    # Annotation ------------------------------------------------------------------------------------------------------
    # observe({
    #   golem::message_dev("TABLE STATE")
    #   golem::print_dev(table_state())
    #   golem::print_dev(selected_row_nr())
    #   golem::print_dev(table$selected_recording)
    # })


    # initial input update of selected species to confitm
    observe({
      selected <-
        ifelse(
          table$selected_recording$species_code_annotated == "",
          table$selected_recording$species_code,
          table$selected_recording$species_code_annotated
        )
      updateSelectizeInput(
        session = session,
        inputId = "select_new_species_code",
        # choices = sort(unique(table$data$common)),
        selected = selected
      )
    }) |> bindEvent(table$selected_recording)

    # patch api and update local data
    observe({
      uid <- table$selected_recording$uid
      resp <- patch_species_annotation(
        url = url,
        uid = uid,
        species_code_annotated = input$select_new_species_code
      )
      # resp <- response(418)
      if (httr2::resp_is_error(resp)) {

        shiny::showNotification(
          sprintf("Error writting to database:\n %s %s", httr2::resp_status(resp), httr2::resp_status_desc(resp)),
          type = "error"
        )
      } else {
        table$selected_recording$species_code_annotated <-
          input$select_new_species_code

        table$selected_recording$common_annotated <-
          all_categories$common[all_categories$code == input$select_new_species_code]

        table$data <-
          table$data |>
          dplyr::rows_update(table$selected_recording, by = "uid")}
    }) |> bindEvent(input$confirm_species)

    # update table
    observe({
      updateReactable(
        "table",
        data = table$data,
        selected = selected_row_nr(),
        page = table_state()$page
      )
    }) |> bindEvent(table$data)

    # Render Table ----------------------------------------------------------------------------------------------------
    # first render table with empty data.
    # then update data once. THis is necessary to update data, selection and page late so that we dont loose it when updating data
    observe({
      table$init <- table$data |> dplyr::slice(0)
    }) |> bindEvent(table$data, once = TRUE)

    observe({
      req(table_state()$page)
      updateReactable("table", data = table$data)
    }) |> bindEvent(table_state(), once = TRUE)


    output$table <- renderReactable({
      golem::message_dev("DRAWING TABLE")
      reactable(
        table$init,
        defaultSorted = list(datetime_precise = "desc"),
        filterable = TRUE,
        resizable = TRUE,
        highlight = TRUE,
        # outlined = TRUE,
        borderless = TRUE,
        selection = "single",
        onClick = "select",
        elementId = "detections-list",
        showPageSizeOptions = TRUE,
        pageSizeOptions = c(5, 10, 25),
        defaultPageSize = 10,
        theme = reactableTheme(
          rowSelectedStyle = list(backgroundColor = "#eee", boxShadow = "inset 2px 0 0 0 #ffa62d")
        ),
        columns = list(
          .selection = colDef(show = FALSE),
          recorder_id = colDef(
            name = "Recorder ID",
            filterInput = dataListFilter("detections-list")
          ),
          datetime = colDef(show = FALSE),
          datetime_precise = colDef(name = "Datetime"),
          start = colDef(show = FALSE),
          end = colDef(show = FALSE),
          common = colDef(
            name = "Species",
            filterInput = dataListFilter("detections-list")
          ),
          snippet_path = colDef(show = FALSE),
          scientific = colDef(show = FALSE),
          scientific_annotated = colDef(show = FALSE),
          species_code = colDef(show = FALSE),
          species_code_annotated = colDef(show = FALSE),
          common_annotated = colDef(name = "Annotated", show = TRUE),
          snippet_path = colDef(show = FALSE),
          uid = colDef(show = FALSE),
          sound_play = colDef(show = FALSE),
          lat = colDef(show = FALSE),
          lon = colDef(show = FALSE),
          confirmed = colDef(show = FALSE),
          confidence = colDef(
            format = colFormat(digits = 2, locales = "en-US"),
            maxWidth = 150,
            filterable = TRUE,
            filterMethod = JS(
              "function(rows, columnId, filterValue) {
                return rows.filter(function(row) {
                  return row.values[columnId] >= filterValue
                })
              }"
            )
          )
        )
      )
    })
  })
}

## To be copied in the UI
# mod_detections_table_ui("detections_table_1")

## To be copied in the server
# mod_detections_table_server("detections_table_1")
