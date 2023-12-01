#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny pkgload
#' @noRd
app_server <- function(input, output, session) {
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
  mod_detections_table_server("detections_table_1", data_filtered, url = url)


  # Phenology -------------------------------------------------------------------------------------------------------
  mod_phenology_server("phenology_1", data = data_filtered, url = url)


  # Health ----------------------------------------------------------------------------------------------------------
  mod_health_server("health_1", data_filtered)

  # CallCamXXMWR
  callcam_server("callcamXX", data = data_filtered)

  # BirdWikiXXMWR
  mod_ebird_server("ebird_1")
}
