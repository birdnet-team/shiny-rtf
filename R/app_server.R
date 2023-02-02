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


  # Get Detections and logs
  data <- mod_get_data_daterange_server("get_data_daterange_1", url)

  observe({
    golem::message_dev("DATA")
    golem::print_dev(dplyr::glimpse(data$detections))
    golem::print_dev(dplyr::glimpse(data$logs))
    golem::print_dev(data$detections$datetime[1:2])
    golem::print_dev(data$logs$datetime_pi[1:2])
  })


  mod_status_overview_server("status_overview_1", data)
  # detections_filtered <- mod_filter_detections_server("filter_detections_1", detections)
  #
 mod_detections_table_server("detections_table_1", data)
}
