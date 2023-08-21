library(shiny)
library(shinyWidgets)
library(leaflet)
library(reactable)
library(dplyr)
library(lubridate)
library(av)
library(reactable)

# detections_table UI-Funktion
mod_detections_table_ui <- function(id) {
  ns <- NS(id)

  sidebarLayout(
    sidebarPanel(
      uiOutput("ja"), HTML("<br/>"),
      uiOutput("nein"), HTML("<br/>"),
      uiOutput("vllt")
    ),

    mainPanel(
      reactableOutput("detections-list"),
      leafletOutput("map"),
      conditionalPanel(
        condition = "output.show_spec_panel",
        plotOutput("spectrogram"),
        uiOutput("audio_controls"),
        sliderInput(
          inputId = ns("max_freq"),
          label = "max. frequency (kHz)",
          ticks = FALSE,
          value = 24,
          max = 24,
          min = 1,
          step = 0.5
        ),
        selectInput(
          inputId = ns("fft_window_length"),
          label = "window length (FFT)",
          choices = c("512", "1024", "2048"),
          multiple = FALSE,
          selectize = TRUE,
          selected = "1024"
        ),
        sliderInput(
          inputId = ns("fft_overlap"),
          label = "overlap (FFT)",
          ticks = FALSE,
          value = 0.75,
          min = 0.60,
          max = 0.98,
          step = 0.01
        )
      )
    )
  )
}

# detections_table Server-Funktionen
mod_detections_table_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$ja <- renderUI({
      actionButton(
        "ja",
        label = "Ja"
      )
    })

    table_selected <- reactive(getReactableState("detections-list", "selected"))

    observeEvent(input$ja, {
      df <- table_dats()
      ind <- table_selected()
      df[ind, "confirmed"] <- TRUE
      updateReactable("detections-list", data = df)
    })

    output$nein <- renderUI({
      actionButton(
        "nein",
        label = "Nein"
      )
    })

    observeEvent(input$nein, {
      df <- table_dats()
      ind <- table_selected()
      df[ind, "confirmed"] <- FALSE
      updateReactable("detections-list", data = df)
    })

    output$vllt <- renderUI({
      actionButton(
        "vllt",
        label = "Vielleicht"
      )
    })

    observeEvent(input$vllt, {
      df <- table_dats()
      ind <- table_selected()
      df[ind, "confirmed"] <- NA
      updateReactable("detections-list", data = df)
    })

    output$map <- renderLeaflet({
      req(data$detections)
      leaflet() %>%
        addTiles(group = "OpenStreetMap") %>%
        addProviderTiles("Esri.WorldImagery", group = "Satellit") %>%
        addMarkers(data = data$detections, lat = ~lat, lng = ~lon,
                   popup = ~paste("Species: ", common, "<br>Time: ", datetime))
    })

    table_dats <- reactive({
      req(data$detections)
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
    })

    input_fft_overlap <- reactive({
      input$fft_overlap
    }) |> debounce(200)

    input_max_freq <- reactive({
      input$max_freq
    }) |> debounce(200)

    audio_selected_detection <- reactiveValues(
      url = NULL,
      fft_data = NULL
    )

    selected_audio_url <- reactive({
      selected_row_index <- reactable::getReactableState("detections-list", "selected", session)
      table_dats() |>
        slice(selected_row_index) |>
        pull("sound_play")
    })

    output$show_spec_panel <- reactive({
      isTruthy(selected_audio_url())
    })
    outputOptions(output, "show_spec_panel", suspendWhenHidden = FALSE)

    audio_file_path <- reactive({
      req(selected_audio_url())
      destfile <- tempfile(fileext = ".ogg")
      download.file(selected_audio_url(), destfile, mode = "wb")
      destfile
    }) |>
      bindCache(selected_audio_url())

    fft_data <- reactive({
      req(audio_file_path())
      av::read_audio_fft(
        audio_file_path(),
        window = av::hanning(input$fft_window_length),
        overlap = input_fft_overlap()
      )
    })

    observe({
      spec_sr <- attr(fft_data(), "sample_rate") / 1000 / 2
      updateNumericInput(
        session = session,
        inputId = "max_freq",
        value = spec_sr,
        max = spec_sr
      )
    }) |> bindEvent(fft_data(), once = TRUE)

    output$spectrogram <- renderPlot({
      req(fft_data())
      plot_av_fft(fft_data(), kHz = TRUE, max.freq = input_max_freq())
    })

    output$audio_controls <- renderUI({
      div(
        tags$audio(
          src = selected_audio_url(),
          type = "audio/ogg",
          controls = NA
        ),
        style = "margin-top: 10px; margin-bottom: 10px"
      )
    }) |>
      bindCache(audio_file_path())

    output$detections-list <- renderReactable({#####
      reactable(
        table_dats(),
        defaultSorted = list(datetime_precise = "desc"),
        filterable = TRUE,
        resizable = TRUE,
        highlight = TRUE,
        borderless = TRUE,
        selection = "multiple",
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
          species_code = colDef(show = FALSE),
          snippet_path = colDef(show = FALSE),
          uid = colDef(show = FALSE),
          sound_play = colDef(show = FALSE),
          lat = colDef(show = TRUE),
          lon = colDef(show = TRUE),
          confirmed = colDef(
            show = TRUE,
            cell = function(value, metadata) {
              if (isTRUE(value)) {
                tagList(tags$span(style = "color: green;", "Ja"))
              } else if (isFALSE(value)) {
                tagList(tags$span(style = "color: red;", "Nein"))
              } else {
                tagList(tags$span(style = "color: orange;", "Vielleicht"))
              }
            }
          ),
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

# Shiny-App
# ui <- fluidPage(
#   mod_detections_table_ui("detections_table_1")
# )
#
# server <- function(input, output) {
#   mod_detections_table_server("detections_table_1", data = list(detections = NULL))
# }
#
# shinyApp(ui, server)
