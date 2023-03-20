#' sound_table UI Function
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

library(rjson)
library(RCurl)
library(htmltools)

#install.packages("remotes")
#usethis::create_github_token("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")
#usethis::edit_r_environ() #and add the token as `GITHUB_PAT`.
remotes::install_github("Athospd/wavesurfer")
library(wavesurfer)

#Setting up: wavesurfer



mod_sound_table_ui <- function(id, detections) {
  ns <- NS(id)
  tagList(
    h5("Spectrogram"),
    wavesurferOutput(("my_ws")),
    tags$div(id = "AUDIO_MY"),
    tags$p("Press spacebar to toggle play/pause."),
    actionButton(ns("mute"), "Mute", icon = icon("volume-off")),
    tags$p("Did you hear a bird?"),
    actionButton("yes", "Yes", icon = icon("XXX")),
    actionButton(ns("maybe"), "Maybe", icon = icon("XXX")),
    tags$p("You couldn't hear a bird? What do you think you heard?"),
    ##XXX Textfeld für Labeling-Input
    reactableOutput(ns("table"))
  )
}

#' detections_table Server Functions
#'
#' @param id Internal parameter for {shiny}
#' @param detections reactive
#'
#' @noRd
mod_sound_table_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    dats <- reactive({
      req(data$detections)
      data$detections %>%
        dplyr::mutate(
          datetime = strftime(datetime, "%F %T", tz = lubridate::tz(datetime)),
          sound_url = paste0('https://reco.birdnet.tucmi.de/reco/det/', uid, '/audio')
        ) %>%
        dplyr::relocate(common, .after = recorder_id)
    })

    observe({
      golem::message_dev("DATA DETECTIONS")
      golem::print_dev(dplyr::glimpse(dats()))
    })

    output$table <- renderReactable({
      reactable(
        dats(),
        defaultSorted = list(datetime = "desc"),
        filterable = TRUE,
        resizable = TRUE,
        highlight = TRUE,
        outlined = TRUE,
        compact = TRUE,
        selection = "single",
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
            name = "sound",
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
        onClick = JS(function())
        # JS("function(rowInfo, column) {
        #   // Only handle click events on the 'details' column
        #   //if (column.id !== 'audio') {
        #   //  return
        #   //}
        #
        #   // Display an alert dialog with details for the row
        #   //window.alert('Details for row ' + rowInfo.index + ':\\n' + rowInfo.values.audio_url)
        #   //var audio_url = 'https://reco.birdnet.tucmi.de/reco/det/' + rowInfo.values.uid + '/audio'
        #
        #   var audio_url =  rowInfo.values.audio_url
        #   var audio = new Audio(audio_url);
        #   audio.play();
        #
        #   // Send the click event to Shiny, which will be available in input$show_details
        #   // Note that the row index starts at 0 in JavaScript, so we add 1
        #   //if (window.Shiny) {
        #   //  Shiny.setInputValue('show_details', { index: rowInfo.index + 1 }, { priority: 'event' })
        #   //}
        # }")
      )
    })

    observe({
      # row <- GET SELECTED ROW FROM TABLE
      # selected_sound_url(row)
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

    ##implementing NEAL

    #wavesurfer ##Spectrogram
    #output$my_ws <- renderWavesurfer({

    #req(selected_audio_url() != "None")

    #1) download & convert selected audio
    #webserver kit for web audio needed!!!
    #Play <- self.wavesurfer.load(selected_audio_url(), peaks);
    #wavesurfer.load(selected_audio_url())
    # solution: import WebAudio from 'wavesurfer.js/src/webaudio.js'

    #2) play audio as .wav via wavesurfer(audio = selected_audio_url()) %>%
    #wavesurfer(audio = wavesurfer.load('selected_audio_url()'))%>%
    #wavesurfer(audio = "http://ia902606.us.archive.org/35/items/shortpoetry_047_librivox/song_cjrg_teasdale_64kb.mp3")%>%

    #3: wavesurfer(audio = selected_audio_url()) %>%
    #wavesurfer(audio = "https://reco.birdnet.tucmi.de/reco/det/160cb181-0ce2-4508-8a56-bf45b6205ae6/audio")%>%
    #wavesurfer(audio = "audio_url") %>%
    #ws_set_wave_color('#5511aa') %>%
    #ws_spectrogram() %>%
    #ws_cursor()
    #})

    #observeEvent(input$mute, {
    #  ws_toggle_mute("my_ws")
    #})

    #observeEvent(input$yes, {
    #ws_toggle_mute("my_ws")#change ()

    #})

    #observeEvent(input$maybe, {
    #ws_toggle_mute("my_ws")#change ()
    #})

  })
}

## To be copied in the UI
# mod_detections_table_ui("detections_table_1")

## To be copied in the server
# mod_detections_table_server("detections_table_1")
