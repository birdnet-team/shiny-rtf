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
        extra = reactableOutput(ns(
          "table"
        )),
        actionButton(ns("correctButton"), "Correct"),
        actionButton(ns("incorrectButton"), "Incorrect"),
        actionButton(ns("setToNAButton"), "Set to NA"),
        heading = "Detections",
        #textInput("date", "Gib das Datum ein (z.B. 2023-08-23):"),
        #textInput("camera", "Gib den Kameranamen ein (z.B. HI001_Cam1):"),
        actionButton(ns("show_images"), "Bilder anzeigen"),
        uiOutput(ns("image_previews"))
      )
    ),
    column(
      5,
      conditionalPanel(
        ns = ns,
        condition = "!output.show_spec_panel",
        shinyWidgets::panel(
          heading = "Spectrogram",
          div(
            p("No media selected or available"),
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
mod_detections_table_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    rv <- reactiveValues(df = xxx)

    # detection data to be displayed in table
    table_dats <- reactive({
      req(data$detections)
      data$detections %>%
        #mutate(datetime_precise = datetime + seconds(start), ) %>%
        mutate(
          #datetime_precise = strftime(datetime_precise, "%F %T", tz = lubridate::tz(datetime)),
          datetime = strftime(datetime, "%F %T", tz = lubridate::tz(datetime)),
          verification = c("unproved"), #set to not proofed
          sound_play = paste0(
            "https://reco.birdnet.tucmi.de/reco/det/",
            uid,
            "/audio"
          ),
          #test for 1 image
          #camera_url = "https://reco.birdnet.tucmi.de/reco/rec/Camera/2023-08-23/HI001_Cam1_2023-08-23_16-10-01.jpg",
        #  image_urls = Image_URL,
          ###proof example
          #camera path: /volume1/backup/seaweedfs/buckets/birdnet-reco/BirdNET-HI001/Camera/2023-08-23/HI001_Cam1_2023-08-23_16-10-01.jpg
          #example: HI001_Cam1_2023-08-23_16-10-01.jpg
#[1] "https://reco.birdnet.tucmi.de/reco/BirdNET-HI001/Camera/2023-08-23/HI001_Cam1"
#/volume1/backup/seaweedfs/buckets/birdnet-reco/BirdNET-HI001/Camera/2023-08-23/HI001_Cam1_2023-08-23_171001.jpg

        ) %>%
        dplyr::relocate(common, .after = recorder_id)
    })


    ###Display images

    observeEvent(input$show_images, {
      if (!is.null(input$show_images)) {
        #image_urls <- generate_image_urls(input$date, input$camera)

        images <- lapply(function(camera_url) {
          img <- tags$img(src = camera_url, width = "100%")
          return(img)
        })

        output$image_previews <- renderUI({
          tagList(images)
        })
      }
    })


#     generate_image_urls <- function(date, camera) {
#       base_url <- "https://reco.birdnet.tucmi.de/reco/BirdNET-HI001/Camera/"
#       folder <- paste("23-08-23/") # get also timestamp
# #https://reco.birdnet.tucmi.de/reco/BirdNET-HI001/Camera/2023-08-23/HI001_Cam1_2023-08-23_16-10-01.jpg
#       # URLs der Bilder generieren
#       image_filenames <- c("HI001_Cam1_2023-08-23_16-10-01.jpg")
#
#       image_urls <- file.path(base_url, folder, image_filenames)
#       return(image_urls)
#       print("got_image")
#     }




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
      selected_row_index <-
        reactable::getReactableState("table", "selected", session)
      table_dats() |>
        slice(selected_row_index) |>
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

    #verification function (mwr changes)
    table_selected <- reactive(getReactableState("table", "selected", session))

    observeEvent(input$correctButton, {
      print("clicked")
      ind <- reactable::getReactableState("table", "selected", session)
      if (!is.null(ind)) {
        df <- table_dats()
        df[ind, "verification"] <- "correct"
        rv$df <- df
        updateReactable("table", data = df)  # Corrected argument name here
      }
    })

    observeEvent(input$incorrectButton, {
      ind <- reactable::getReactableState("table", "selected", session)
      if (!is.null(ind)) {
        df <- table_dats()
        df[ind, "verification"] <- "Incorrect"
        rv$df <- df
        updateReactable("table", data = df)
      }
    })

    observeEvent(input$setToNAButton, {
      ind <- reactable::getReactableState("table", "selected", session)
      if (!is.null(ind)) {
        df <- table_dats()
        df[ind, "verification"] <- "NA"
        rv$df <- df
        updateReactable("table", data = df)
      }
    })

    output$table <- renderReactable({
      combined_data <- bind_rows(rv$df, table_dats())
      reactable(combined_data,
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
                  .selection = colDef(show = TRUE),
                  recorder_id = colDef(
                    name = "Recorder ID",
                    filterInput = dataListFilter("detections-list"),
                    filterable = TRUE
                  ),
                 # camera_url = colDef(show = TRUE),##
                 # Image_URL = colDef(show = TRUE),
                  verification = colDef(
                    name = "Verification",
                    html = TRUE,
                    filterable = TRUE
                  ),
                  datetime = colDef(name = "Datetime", filterable = TRUE),
                  start = colDef(show = FALSE),
                  end = colDef(show = FALSE),
                  common = colDef(
                    name = "Species",
                    filterInput = dataListFilter("detections-list"),
                    filterable = TRUE
                  ),
                  snippet_path = colDef(show = FALSE),
                  scientific = colDef(show = FALSE),
                  species_code = colDef(show = FALSE),
                  uid = colDef(show = FALSE),
                  sound_play = colDef(show = TRUE),
                  lat = colDef(show = FALSE),
                  lon = colDef(show = FALSE),

                  confidence = colDef(
                    name = "Confidence",
                    #format = colFormat(digits = 2, locales = "en-US"),
                    maxWidth = 150,
                    filterable = TRUE,
                    filterMethod = JS(
                      "function(rows, columnId, filterValue) {
                    return rows.filter(function(row) {
                      return row.values[columnId] >= filterValue
                    })
                  }"
                    )
                  ),
                  confirmed = colDef(show = FALSE)
               )
            )
       })




    })
}

#is needed for combining 2 tables as a empty placeholder for a data frame to realize the function, it will lose function without it
xxx <- data.frame()

