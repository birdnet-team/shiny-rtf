#' get_data_daterange UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import waiter
mod_get_data_daterange_ui <- function(id) {
  ns <- NS(id)
  tagList(
    waiter::useWaitress(),
    tags$div(
      # for waitress to work, pickerInput needs to be wrapped in a div with an ID
      id = "tr-btn",
      shinyWidgets::pickerInput(
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
        selected = 12,
        options = list(`style` = "btn-default")
      )
    )
  )
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
mod_get_data_daterange_server <- function(id, url, tz_server = NULL, tz_out = NULL) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    waitress <- waiter::Waitress$new("#tr-btn", theme = "overlay-opacity", min = 0, max = 100, infinit = TRUE)

    # rV that holds all downloaded data, detections and logs
    data <-
      reactiveValues(
        detections = NULL,
        logs = NULL,
        recorders = NULL
      )

    # rV
    # - filtered on input timerange (one might start with 'last 24h' but then wants filter to 'last 6h')
    # - new timezone applied
    data_return <-
      reactiveValues(
        detections = NULL,
        logs = NULL,
        recorders = NULL
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

    # RECORDERS
    # get recorder data onl once
    observe({
      golem::message_dev("GET Recorders")
      waitress$start()
      data$recorders <-
        get_recorders(url) %>%
        filter(recorder_id != "BirdNET-HI004")
      waitress$close()
    }) %>% bindEvent(datetime_range$start, once = TRUE)


    # DETECTIONS
    observe({
      waitress$start()
      params <- list("datetime__gte" = datetime_range$start)
      golem::message_dev("GET DETECIONS")
      golem::print_dev(params)
      data$detections <-
        get_detections(url, params) %>%
        dplyr::mutate(datetime = lubridate::force_tz(datetime, tz_server)) %>%
        dplyr::left_join(birdnames, by = c("species_code" = "code"))
      waitress$close()
    }) %>% bindEvent(datetime_range$start)

    # LOGS
    observe({
      waitress$start()
      params <- list("datetime_pi__gte" = datetime_range$start)
      golem::message_dev("LOG")
      golem::print_dev(params)
      data$logs <-
        get_log(url, params) %>%
        dplyr::mutate(datetime_pi = lubridate::force_tz(datetime_pi, tz_server))
      waitress$close()
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


    # change timezone
    observe({
      req(tz_out())
      data_return$detections <-
        data$detections %>%
        dplyr::mutate(datetime = lubridate::with_tz(datetime, tz_out()))

      data_return$logs <-
        data$logs %>%
        dplyr::mutate(datetime_pi = lubridate::with_tz(datetime_pi, tz_out()))

      data_return$recorders <- data$recorders
    }) %>% bindEvent(tz_out(), data$detections)


    return(data_return)
  })
}

## To be copied in the UI
# mod_get_data_daterange_ui("get_data_daterange_1")

## To be copied in the server
# mod_get_data_daterange_server("get_data_daterange_1")
