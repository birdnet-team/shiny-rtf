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
mod_sound_ui <- function(id) {
  ns <- NS(id)
  tagList(reactableOutput(ns("table")))
}

#' detections_table Server Functions
#'
#' @param id Internal parameter for {shiny}
#' @param detections reactive
#'
#' @noRd
mod_sound_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
#plotting data for download


    table_dats <- reactive({
      req(data$detections)
      data$detections %>%
        mutate(
          datetime = strftime(datetime, "%F %T", tz = lubridate::tz(datetime)),
          #sound url zusammensetzen
          sound_url = paste0('https://reco.birdnet.tucmi.de/reco/det/', uid, '/audio'),
        ) %>%
        dplyr::relocate(common, .after = recorder_id)
    })

    #create an observe
    observe({
      golem::message_dev("DATA DETECTIONS")
      golem::print_dev(dplyr::glimpse(dats()))
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
        ###
        selection = "multiple",
        elementId = "detections-list",
        columns = list(
          uid = colDef(show = FALSE),
          recorder_id = colDef(
            name = "Recorder ID",
            filterInput = dataListFilter("detections-list")
          ),
          datetime = colDef(
            name = "Datetime"
            #format = colFormat(datetime = TRUE)
          ),
          start = colDef(show = FALSE),
          end = colDef(show = FALSE),
          common = colDef(
            name = "Species",
            filterInput = dataListFilter("detections-list")
          ),
          scientific = colDef(show = FALSE),
          species_code = colDef(show = FALSE),
          snippet_path = colDef(
            name = "audio",
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
        #definieren, was selectiert werden soll
        onClick = "select"
      )
    })

    soundDownload <- selected_sound_url()
    output$downloadData = downloadHandler(
      #download.file("soundDownload", tf <- tempfile(fileext = ".mp3"), mode="wb")
      download.file(soundDownload, destfile, method, quiet = FALSE, mode = "wb",
                    cacheOK = TRUE,
                    extra = getOption("download.file.extra"),
                    headers = NULL))
    #)

  })
}

observe({
  # row <- GET SELECTED ROW FROM TABLE
  #golem::selected_audio_url(row)
  golem::message_dev("SELECTED")
  golem::print_dev(selected())
  golem::print_dev(selected_sound_url())

})

selected <- reactive(getReactableState("table", "selected", session = session))
selected_sound_url <- reactive({
#  dats() %>%
#    dplyr::slice(selected()) %>%
#    dplyr::pull(sound_url)
#    download.file(sound_url)
})











## To be copied in the UI
# mod_detections_table_ui("detections_table_1")

## To be copied in the server
# mod_detections_table_server("detections_table_1")
