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
#' @import dplyr

library(shiny)
library(tuneR)
library(seewave)
library(av)

mod_detections_table_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fileInput(ns("file"), label = "Choose an ogg or wav file"),
    plotOutput(ns("spectrogram")),
    downloadButton(ns("download"), label = "Download WAV-Datei"),
    reactableOutput(ns('table'))
  )
}

#' @param id Internal parameter for {shiny}
#' @param data Reactive data containing detections
#'
#' @noRd
mod_detections_table_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    table_dats <- reactive({
      req(data$detections)
      data$detections %>%
        mutate(
          datetime = strftime(datetime, "%F %T", tz = lubridate::tz(datetime)),
          sound_play = paste0('https://reco.birdnet.tucmi.de/reco/det/', uid, '/audio'),

        ) %>%
        dplyr::relocate(common, .after = recorder_id)
    })

    observe({
      golem::message_dev("DATA DETECTIONS")
      golem::print_dev(dplyr::glimpse(dats()))
    })


    observeEvent(input$file, {
      inFile <- input$file

      if (!is.null(inFile)) {
        wav_file <- tempfile(fileext = ".wav")

        av_audio_convert(
          inFile$datapath,
          output = wav_file,
          format = "wav",
          verbose = TRUE
        )

        output$spectrogram <- renderPlot({
          audio <- readWave(wav_file)
          sample_rate <- 16000
          duration <- 5
          num_samples <- sample_rate * duration
          extracted_audio <- audio[1:num_samples]
          spectro(extracted_audio, f = sample_rate, wl = 512, wn = "hanning", ovlp = 50,
                  collevels = seq(-80, 0, 1), palette = temp.colors, grid = FALSE,
                  colbg = "black", collab = "white", colaxis = "white", fftw = TRUE,
                  flog = TRUE, noisereduction = 2)

        })

        output$download <- downloadHandler(
          filename = function() {
            paste0(tools::file_path_sans_ext(inFile$name), ".wav")
          },
          content = function(file) {
            file.copy(wav_file, file)
          }
        )
      }
    })

    output$table <- renderReactable({
      reactable(
        table_dats(),
        defaultSorted = list(datetime = "desc"),
        filterable = TRUE,
        resizable = TRUE,
        highlight = TRUE,
        outlined = TRUE,
        compact = TRUE,
        selection=list(mode="single", target="cell"),
        elementId = "detections-list",
        columns = list(
          recorder_id = colDef(
            width = 150,
            name = "Recorder ID",
            filterInput = dataListFilter("detections-list")
          ),
          datetime = colDef(
            width = 150,
            name = "Datetime"
          ),
          start = colDef(show = FALSE),
          end = colDef(show = FALSE),
          common = colDef(
            width = 150,
            name = "Species",
            filterInput = dataListFilter("detections-list")
          ),
          scientific = colDef(show = FALSE),
          species_code = colDef(show = FALSE),
          snippet_path = colDef(show = FALSE),
          uid = colDef(show = FALSE),
          sound_play = colDef(
            name = "Audio",
            html = TRUE,
            cell = function(value) {
              if (value == "None") {
                '<i class="fa-solid fa-music", style = "color:#eaecee "></i>'
              } else {
                paste0('<audio controls><source src="', value, '" type="audio/wav"></audio>')
              }
            }
          ),
          lat = colDef(show = FALSE),
          lon = colDef(show = FALSE),
          confirmed = colDef(show = FALSE),
          confidence = colDef(
            width = 130,
            filterable = TRUE,
            filterMethod = JS("function(rows, columnId, filterValue) {
                return rows.filter(function(row) {
                  return row.values[columnId] >= filterValue
                })
              }"),
          )
        ),
        onClick = JS("function(rowInfo, column) {
            // Only handle click events on the 'details' column
            //if (column.id !== 'audio') {
            //  return
            //}

            // Display an alert dialog with details for the row
            //window.alert('Details for row ' + rowInfo.index + ':\\n' + rowInfo.values.audio_url)
            var audio_url = 'https://reco.birdnet.tucmi.de/reco/det/' + rowInfo.values.uid + '/audio'
            var audio = new Audio(audio_url);
            audio.play();

            // Send the click event to Shiny, which will be available in input$show_details
            // Note that the row index starts at 0 in JavaScript, so we add 1
            //if (window.Shiny) {
            //  Shiny.setInputValue('show_details', { index: rowInfo.index + 1 }, { priority: 'event' })
            //}
          }")
      )
    })


  })


}
