#' Get Data for Landing Page
#'
#' @description Download the initial data needed to display a landing page.
#'
#' @param url The base URL of the REST API.
#' @param latest_hours The number of hours to look back for detections (default: 24).
#' @param tz_server The time zone of the server (default: NULL, uses system's time zone).
#'
#' @return A list containing recorders, detections, and logs.
#' @noRd

get_data_landingpage <-
  function(url,
           latest_hours = 24L,
           tz_server = NULL) {
    # Initialize lists -------------------------------------------------------------

    # List to hold downloaded data, detections, and logs
    data <- list(
      detections = NULL,
      logs = NULL,
      recorders = NULL
    )

    # List to store start and end times
    datetime_range <- list(start = NULL, end = NULL)
    datetime_range$end <- lubridate::now(tz_server)
    datetime_range$start <-
      datetime_range$end - lubridate::hours(latest_hours)

    # Get Recorders ----------------------------------------------------------------

    data$recorders <- get_recorders(url)

    # Get Detections ---------------------------------------------------------------
    # (for the last 24 hours by default)

    params <- list("datetime__gte" = datetime_range$start)
    data$detections <- get_detections(url, params) %>%
      dplyr::mutate(datetime = lubridate::force_tz(datetime, tz_server)) %>%
      dplyr::left_join(birdnames, by = c("species_code" = "code"))

    # Get Logs ---------------------------------------------------------------------
    # (get all logs, because there is no way to only get the latest logs,
    # but we want to make sure to have at least one log for every recorder)

    data$logs <- get_log(url)

    return(data)
  }
