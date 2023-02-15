#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd

# install.packages("remotes")
remotes::install_github("Athospd/wavesurfer")
library(wavesurfer)

app_server <- function(input, output, session) {

  #Spectrogram
   output$my_ws <- renderWavesurfer({
     PlaySnippet <- ("'https://reco.birdnet.tucmi.de/reco/det/002395f6-52be-44e0-ba76-a0f7c5dcfa1c/audio'")%>%

    #wavesurfer(audio = "http://ia902606.us.archive.org/35/items/shortpoetry_047_librivox/song_cjrg_teasdale_64kb.mp3") %>%
    #playAudio <- filepath = "Recording.objects.get(pk=pk).snippet_path"
    #wavesurfer(filepath = Recording.objects.get(pk=pk)) %>%
    #wavesurfer(audio = "https://wavesurfer-js.org/example/media/demo.wav") %>%
    #wavesurfer(audio = "'https://reco.birdnet.tucmi.de/reco/det/' + rowInfo.values.uid + '/audio'") %>%
    #wavesurfer(audio = "snippet_path") %>%

    #wavesurfer(audio = "https://reco.birdnet.tucmi.de/reco/det/002395f6-52be-44e0-ba76-a0f7c5dcfa1c/audio") %>%
    wavesurfer(audio = "PlaySnippet")%>%

     #wavesurfer.load('audio.wav');
      #if (audioPlay == TRUE)#wenn audioButton gedrückt und Musik gespielt wird: wie heißt das AudioSymbol?
      #{
      #  wavesurfer(audio = "url")#das was für die audio.url deklariert ist
      #}

      ws_set_wave_color('#5511aa') %>%
      ws_spectrogram() %>%
      ws_cursor()
  })

  observeEvent(input$mute, {#new
    ws_toggle_mute("my_ws")#new
  })#new

  observeEvent(input$yes, {#new
    ws_toggle_mute("my_ws")#new
  })#new

  observeEvent(input$maybe, {
    ws_toggle_mute("my_ws")
  })



  # Your application server logic
  url <- "https://reco.birdnet.tucmi.de/reco"


  # Authentication --------------------------------------------------------------------------------------------------
  mod_sign_out_server("sign_out_1")


  # Header ----------------------------------------------------------------------------------------------------------
  tz <- mod_set_timezone_server("set_timezone_1")
  observe({
    golem::message_dev("TZ")
    golem::print_dev(tz())
  })

  # Get Detections and logs
  data <- mod_get_data_daterange_server("get_data_daterange_1", url, tz_server = "HST", tz_out = tz)

  data_filtered <- mod_global_filter_server("global_filter_1", data)

  # remove waiter
  observe({
    req(data_filtered$detections)
    waiter::waiter_hide()
  }) %>% bindEvent(data_filtered$detections)

  # Overview --------------------------------------------------------------------------------------------------------
  mod_status_overview_server("status_overview_1", data_filtered)
  # detections_filtered <- mod_filter_detections_server("filter_detections_1", detections)
  #
  mod_detections_table_server("detections_table_1", data_filtered)


  # Health ----------------------------------------------------------------------------------------------------------
  mod_health_server("health_1", data_filtered)

}
