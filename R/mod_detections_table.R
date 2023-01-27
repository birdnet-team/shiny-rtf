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
  tagList(reactableOutput(ns("table")))
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

    output$table <- renderReactable({
      req(data$detections)
      data$detections %>%
        mutate(
          audio_url = ifelse(
            is.na(snippet_path),
            NA,
            paste0("https://reco.birdnet.tucmi.de/reco/det/", uid, "/audio")
          ),
          audio = NA
        ) %>%
        reactable(
          defaultSorted = list(datetime = "desc"),
          filterable = TRUE,
          resizable = TRUE,
          columns = list(
            uid = colDef(show = FALSE),
            recorder_id = colDef(name = "Recorder ID"),
            start = colDef(show = FALSE),
            end = colDef(show = FALSE),
            species_code = colDef(name = "Species Code"),
            lat = colDef(show = FALSE),
            lon = colDef(show = FALSE),
            snippet_path = colDef(show = FALSE),
            confirmed = colDef(show = FALSE),
            audio_url = colDef(show = FALSE),
            audio = colDef(
              filterable = FALSE,
              cell = function(value) htmltools::tags$button(icon("play"))
            )
          ),
          onClick = JS("function(rowInfo, column) {
            // Only handle click events on the 'details' column
            if (column.id !== 'audio') {
              return
            }

            // Display an alert dialog with details for the row
            //window.alert('Details for row ' + rowInfo.index + ':\\n' + rowInfo.values.audio_url)
            var audio = new Audio(rowInfo.values.audio_url);
            audio.play();

            // Send the click event to Shiny, which will be available in input$show_details
            // Note that the row index starts at 0 in JavaScript, so we add 1
            if (window.Shiny) {
              Shiny.setInputValue('show_details', { index: rowInfo.index + 1 }, { priority: 'event' })
            }
          }")
        )
    })
  })
}

## To be copied in the UI
# mod_detections_table_ui("detections_table_1")

## To be copied in the server
# mod_detections_table_server("detections_table_1")
