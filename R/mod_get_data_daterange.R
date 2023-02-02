#' get_data_daterange UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_get_data_daterange_ui <- function(id) {
  ns <- NS(id)
  tagList(selectizeInput(
    ns("timerange"),
    NULL,
    choices = c(
      "Last 1 hour" = 1,
      "Last 2 hours" = 2,
      "Last 6 hours" = 6,
      "Last 12 hours" = 12,
      "Last 24 hours" = 24,
      "Last 3 days" = 72,
      "Last 7 days" = 168,
      "Last 14 days" = 336,
      "All" = NULL
    ),
    selected = 12
  ))
}

#' get_data_daterange Server Functions
#'
#' @param id Internal parameter for {shiny}
#' @param url base url to API
#' @param tz_server the timezone of datetime on server.
#'  GET will return datetimes in UTC and `tz_server` will be forced on timestamp (`lubridate::force_tz()`)
#' @param tz_out timezone of the returned date-time vector. (`lubridate::with_tz()`)
#'
#' @noRd
mod_get_data_daterange_server <- function(id, url, tz_server = "HST", tz_out = "HST") {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # rV that holds all data on detections and logs
    data <-
      reactiveValues(
        detections = NULL,
        logs = NULL
      )

    # rV filtered on input timerange
    # one might start with 'last 24h' but then wants filter to 'last 6h'
    data_timerange <-
      reactiveValues(
        detections = NULL,
        logs = NULL
      )

    # rV that stores start and end
    datetime_range <- reactiveValues(
      start = NULL,
      end = NULL
    )
    # GET data from server.
    # For simplicity, we only GET greater than, and not less than
    # Could be added later.
    # Split getting logs and detections on two oberservers
    # to potentially implement custom data fetching when clicking sidebar items

    # DETECTIONS
    observe({
      params <- list("datetime__gte" = datetime_range$start)
      golem::message_dev("GET DETECIONS")
      golem::print_dev(params)
      data$detections <-
        get_detections(url, params) %>%
        dplyr::mutate(datetime = lubridate::force_tz(datetime, tz_server)) %>%
        dplyr::mutate(datetime = lubridate::with_tz(datetime, tz_out))
    }) %>% bindEvent(datetime_range$start)

    # LOGS
    observe({
      params <- list("datetime_pi__gte" = datetime_range$start)
      golem::message_dev("LOG")
      golem::print_dev(params)
      data$logs <-
        get_log(url, params) %>%
        dplyr::mutate(datetime_pi = lubridate::force_tz(datetime_pi, tz_server)) %>%
        dplyr::mutate(datetime_pi = lubridate::with_tz(datetime_pi, tz_out))
    }) %>% bindEvent(datetime_range$start)

    # DATETIME RANGE; updated via input
    observe({
      if (is.null(input$timerange)) {
        datetime_range$end <- NULL
        datetime_range$start <- NULL
      } else {
        datetime_range$end <- lubridate::now(tz_server)
        datetime_range$start <-
          datetime_range$end - lubridate::hours(input$timerange)
      }
    }) %>% bindEvent(input$timerange)


    return(data)
  })
}

## To be copied in the UI
# mod_get_data_daterange_ui("get_data_daterange_1")

## To be copied in the server
# mod_get_data_daterange_server("get_data_daterange_1")
