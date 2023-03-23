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

remotes::install_github("Athospd/wavesurfer")
library(wavesurfer)

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
          sound_url = paste0('https://reco.birdnet.tucmi.de/reco/det/', uid, '/audio'),
          #onClick
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

        #selection = "single",
        selection=list(mode="single", target="cell"),
        elementId = "detections-list",
        columns = list(
          uid = colDef(show = TRUE),
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
          sound_url = colDef(

            name = "url",
            # html = TRUE,
            # cell = function(value) {
            #   if (value == "None")
            #   {
            #     '<i class="fa-solid fa-download", style = "color:#eaecee "></i>'
            #   } else {
            #     '<i class="fa-solid fa-download", style = "color:#008080"></i>'
            #   }
            # }
          ),
          # snippet_path = colDef(
          #   name = "audio",
          #   html = TRUE,
          #   cell = function(value) {
          #     if (value == "None") {
          #       '<i class="fa-solid fa-music", style = "color:#eaecee "></i>'
          #     } else {
          #       '<i class="fa-solid fa-music", style = "color:#008080"></i>'
          #     }
          #   }
          # ),
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
        #onClick = "select"
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



    output$my_ws <- renderWavesurfer({
      #sound <- input$paste0('https://reco.birdnet.tucmi.de/reco/det/', selected_sound_url, '/audio')
      #wavesurfer(audio = "http://ia902606.us.archive.org/35/items/shortpoetry_047_librivox/song_cjrg_teasdale_64kb.mp3") %>%
      wavesurfer("sound_url") %>%
        ws_set_wave_color('#5511aa') %>%
        ws_spectrogram()
      ws_cursor()
    })

    #downloadHandler
    #output




  })



}#end



observeEvent(input$sound_url, {
  print(input$downloadData)  # JavaScript object has been converted to R List

  # Elements from within returned list can be accessed easily: input$btn_open$name

  # showNotification(
  #   tagList(
  #     "Table button was clicked",
  #     br(),
  #     paste0("Input value: ", input$downloadData$dom_id),
  #     br(),
  #     paste0("ID: ", input$downloadData$row_id),
  #     br(),
  #     paste0("Name: ", input$downloadData$name)
  #   )  # Tag List
  # )  # Notification
  url <- "selected_sound_url"
  destfile <- "C:/Users/ElementXX/Desktop/download_sounds/soundXX.wav"
  download.file(url, destfile, mode = "wb")
})



#observe, wenn button spec geklickt worden ist, dann führe wavesurfer aus:

observeEvent(input$mute, {
  ws_toggle_mute("my_ws")
})

observeEvent(input$yes, {
  ws_toggle_yes("my_ws")
})

observeEvent(input$no, {
  ws_toggle_no("my_ws")
})


observe({
  # row <- GET SELECTED ROW FROM TABLE
  #golem::selected_audio_url(row)
  golem::message_dev("SELECTED")
  golem::print_dev(selected())
  golem::print_dev(selected_sound_url())

})

selected <- reactive(getReactableState("table", "selected", session = session))
selected_sound_url <- reactive({
  dats() %>%
    dplyr::slice(selected()) %>%
    dplyr::pull(sound_url)
})







## To be copied in the UI
# mod_detections_table_ui("detections_table_1")

## To be copied in the server
# mod_detections_table_server("detections_table_1")
