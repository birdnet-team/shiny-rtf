#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  url <- "https://reco.birdnet.tucmi.de/reco"


  # Authentication --------------------------------------------------------------------------------------------------
  mod_sign_out_server("sign_out_1")


  # Get timezone ------------------------------------------------
  tz <- mod_set_timezone_server("set_timezone_1")

  observe({
    req(tz())
    golem::message_dev("TIMEZONE SERVER")
    golem::print_dev(tz())
  })

  # Get Detections and logs
  data <- mod_get_data_daterange_server("get_data_daterange_1", url, tz_server = "HST", tz_out = tz)

  #   observe({
  #   golem::message_dev("DATA")
  #   golem::print_dev(dplyr::glimpse(data$detections))
  #   golem::print_dev(dplyr::glimpse(data$logs))
  #   golem::print_dev(data$detections$datetime[1:2])
  #   golem::print_dev(data$logs$datetime_pi[1:2])
  # })


  mod_status_overview_server("status_overview_1", data)
  # detections_filtered <- mod_filter_detections_server("filter_detections_1", detections)
  #
 mod_detections_table_server("detections_table_1", data)
}
