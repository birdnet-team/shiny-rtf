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

mod_sound_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fileInput(ns("file"), label = "Upload audio file"),
    plotOutput(ns("spectrogram")),
    downloadButton(ns("downloadImage"), label = "Download Spectrogram as image"),
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
          sound_url = paste0('https://reco.birdnet.tucmi.de/reco/det/', uid, '/audio'),
          sound_play = paste0('https://reco.birdnet.tucmi.de/reco/det/', uid, '/audio'),

           ) %>%
        dplyr::relocate(common, .after = recorder_id)
    })

    observe({
      golem::message_dev("DATA DETECTIONS")
      golem::print_dev(dplyr::glimpse(dats()))
    })



    # output$spectrogram <- renderPlot({
    #   if (!is.null(input$file)) {
    #     audio <- readWave(input$file$datapath)
    #     spectro(audio, f = 16000, wl = 1024, wn = "hanning", ovlp = 50, collevels = seq(-80, 0,1), palette= temp.colors, grid=FALSE, colbg = "black", collab="white", colaxis = "white", fftw = TRUE, flog = TRUE, noisereduction = 2)
    #   }
    # })

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
          sound_url = colDef(
            name = "Download",
            html = TRUE,
            cell = function(value) {
              if (value == "None") {
                '<button class="btn btn-primary" disabled>Not available</button>'
              } else {
                paste0('<a href="', value, '" class="btn btn-primary" download>Download</a>')
              }
            }
          ),
          snippet_path = colDef(
            name = "Play Audio",
            html = TRUE,
            cell = function(value) {
              if (value == "None") {
                '<i class="fa-solid fa-music", style = "color:#eaecee "></i>'
              } else {
                '<i class="fa-solid fa-music", style = "color:#008080"></i>'
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

    output$spectrogram <- renderPlot({
      if (!is.null(input$file)) {
        audio <- readWave(input$file$datapath)
        spectro(audio, f = 16000, wl = 1024, wn = "hanning", ovlp = 50, collevels = seq(-80, 0,1), palette= temp.colors, grid=FALSE, colbg = "black", collab="white", colaxis = "white", fftw = TRUE, flog = TRUE, noisereduction = 2)
      }
    })

    output$downloadImage <- downloadHandler(
      filename = function() {
        paste0("spectrogram_", Sys.Date(), ".png")
      },
      content = function(file) {
        if(!is.null(input$file)) {
          audio <- readWave(input$file$datapath)
          img <- ggspectro(audio, ovlp = 50) + geom_tile(aes(fill = amplitude)) + stat_contour()
          ggsave(file, img, dpi = 300, width = 8, height = 6, type = "cairo")
        }
      }
    )

})


}#end
