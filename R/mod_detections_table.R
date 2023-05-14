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
mod_detections_table_ui <- function(id) {
  ns <- NS(id)
  tagList(
    reactableOutput(ns("table")),
    tags$script(
      HTML(
        'function downloadWav(uid) {
           var url = "https://reco.birdnet.tucmi.de/reco/det/" + uid + "/audio.wav"
           var link = document.createElement("a");
           link.download = uid + ".wav";
           link.href = url;
           link.click();
        }'
      )
    )
  )
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

    table_dats <- reactive({
      req(data$detections)
      data$detections %>%
        mutate(
          datetime = strftime(datetime, "%F %T", tz = lubridate::tz(datetime)),
          sound_play = paste0('https://reco.birdnet.tucmi.de/reco/det/', uid, '/audio')

        ) %>%
        dplyr::relocate(common, .after = recorder_id)
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
        elementId = "detections-list",
        columns = list(
          # existing columns...
          sound_play = colDef(
            name = "Audio",
            html = TRUE,
            cell = function(value, index) {
              if (value == "None") {
                '<i class="fa-solid fa-music", style = "color:#eaecee "></i>'
              } else {
                paste0(
                  '<button id="download-', index, '" onclick="downloadAudio(\'', value, '\')">Download</button> ',
                  '<audio controls><source src="', value, '" type="audio/wav"></audio>'
                )
              }
            }
          ),
          # new column
          snippet_path = colDef(
            name = "",
            html = TRUE,
            cell = function(value, index) {
              paste0(
                '<button onclick="downloadWav(\'', table_dats()$uid[index], '\')">Download WAV</button>'
              )
            }
          )
        ),
        onClick = JS("function(rowInfo, column) {
      // existing onClick function...
    }")
      )
    })
  })
}

## To be copied in the UI
# mod_detections_table_ui("detections_table_1")

## To be copied in the server
# mod_detections_table_server("detections_table_1")
