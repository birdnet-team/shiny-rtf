library(shiny)
library(tuneR)
library(signal)
library(seewave)
library(ggplot2)

mod_sound_ui <- function(id) {
  ns <- NS(id)
  tagList(
    reactableOutput(ns("table"))
  )
}

mod_sound_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    table_dats <- reactive({
      req(data$detections)
      data$detections %>%
        mutate(
          datetime = strftime(datetime, "%F %T", tz = lubridate::tz(datetime)),
          sound_url = paste0('https://reco.birdnet.tucmi.de/reco/det/', uid, '/audio'),
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
          ),
          uid = colDef(
            name = "Validation",
            cell = function(value, index, row) {
              actionButton(ns(paste0("btn_", index)), "TRUE",
                           onclick = {
                             write("true", "file.txt", append = TRUE)
                           })
            }
          )
        ),
        onClick = NULL # Remove the previous onClick function

      )
    })

  })
}
