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
library(signal)
library(seewave)
library(ggplot2)
library(av)
require(rgl)
#library(monitoR)
#install.packages("warbleR")
#library(warbleR)

mod_sound_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fileInput(ns("file"), label = "Choose an ogg or wav file"),
    plotOutput(ns("spectrogram")),
    downloadButton(ns("download"), label = "Download WAV-Datei"),
    #downloadButton(ns("downloadImage"), label = "Download Spectrogram as image"),
    reactableOutput(ns('table'))
  )
}

#' detections_table Server Functions
#'
#' @param id Internal parameter for {shiny}
#' @param data Reactive data containing detections
#'
#' @noRd
mod_sound_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    table_dats <- reactive({
      req(data$detections)
      data$detections %>%
        mutate(
          datetime = strftime(datetime, "%F %T", tz = lubridate::tz(datetime)),
          #sound_url = paste0('https://reco.birdnet.tucmi.de/reco/det/', uid, '/audio'),
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
          #original
          #wav <- readWave(wav_file)
          # spectro(wav, f = 16000, wl = 512, wn = "hanning", ovlp = 50, collevels = seq(-80, 0, 1),
          #         palette = temp.colors, grid = FALSE, colbg = "black", collab = "white", colaxis = "white",
          #         fftw = TRUE, flog = TRUE, noisereduction = 2)
          #3D-Darstellung Spectrogram:
          #spectro3D(wav,f=22050,wl=512,ovlp=75,zp=16,maga=4,palette=reverse.terrain.colors)
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
    #end1

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
            name = "Recorder ID",
            filterInput = dataListFilter("detections-list")
          ),
          datetime = colDef(
            name = "Datetime"
          ),
          start = colDef(show = FALSE),
          end = colDef(show = FALSE),
          common = colDef(
            name = "Species",
            filterInput = dataListFilter("detections-list")
          ),
          scientific = colDef(show = FALSE),
          species_code = colDef(show = FALSE),
          uid = colDef(show = FALSE),
          #sound_play(show = FALSE),
          # sound_url = colDef(
          #   show = FALSE,
          #   name = "Download",
          #   html = TRUE,
          #   cell = function(value) {
          #     if (value == "None") {
          #       '<button class="btn btn-primary" disabled>Not available</button>'
          #     } else {
          #       #paste0('<a href="', value, '" class="btn btn-primary" download>Download</a>')
          #       #paste0('<a href="', value, '" class="btn btn-primary" download onclick="blank">Download</a>')
          #     }
          #   }
          # ),
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


    # output$downloadImage <- downloadHandler(
    #   filename = function() {
    #     paste0("spectrogram_", Sys.Date(), ".png")
    #   },
    #   content = function(file) {
    #     if(!is.null(input$file)) {
    #       audio <- readWave(input$file$datapath)
    #       img <- ggspectro(audio, ovlp = 50) + geom_tile(aes(fill = amplitude)) + stat_contour()
    #       ggsave(file, img, dpi = 300, width = 8, height = 6, type = "cairo")
    #     }
    #   }
    # )

  })


}#end
