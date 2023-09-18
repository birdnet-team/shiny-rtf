#' Extract error message from JSON body of an HTTP response
#'
#' @param resp An HTTP response object.
#' @return A named character vector representing the flattened JSON content of the HTTP response body.
#' @examples
#' \dontrun{
#' # Assuming an HTTP response object 'response' with a JSON error body
#' error_body <- ecopi_error_body(response)
#' }
#' @export
api_error_body <- function(resp) {
  resp |>
    httr2::resp_body_json() |>
    unlist()
}

#' Perform get request
#'
#' @param url base URL to api
#' @param path  path to append to base URL
#' @param params parameters to append to URL. Can include Django field lookups.
#'
#' @return API response
#' @export
#'
#' @examples
#' perform_get_request("https://reco.birdnet.tucmi.de/reco", "det", list("recorder_id_id" = "BirdNET-HI111"))
#'
#' @importFrom httr2 request req_cache req_url_path_append req_url_query req_perform
perform_get_request <- function(url, path, params = NULL) {
  api_response <-
    request(url) |>
    req_user_agent("r-api") |>
    #req_error(body = api_error_body) |>
    req_url_path_append(path) |>
    (\(.) {
      if (is.null(params)) {
        .
      } else {
        params <- lapply(params, paste, collapse = ",")
        req_url_query(., !!!params)
      }
    })() |>
    req_cache(tempdir()) |>
    req_perform()

  return(api_response)
}

#' Convert response body to data frame
#'
#' @param api_response Response from API
#'
#' @return Data frame
#' @export
#' @examples
#' api_response <- perform_get_request("https://reco.birdnet.tucmi.de/reco", "det", list("recorder_id_id" = "BirdNET-HI111"))
#' resp_body_json_to_df(api_response)
#' @importFrom httr2 resp_body_json
resp_body_json_to_df <- function(api_response) {
  api_response |>
    resp_body_json() |>
    data.table::rbindlist() |>
    tibble::as_tibble() |>
    identity()
}


#' Retrieve detections from an API
#'
#' @param url The URL of the API
#' @param params Parameters to GET request as list. Can include Django field lookups
#' @return A data frame containing the detections
#' @export
#'
#' @examples
#' params <- list(
#'   "recorder_id_id" = "BirdNET-HI111",
#'   "datetime__gte" = "2023-01-17"
#' )
#' get_detections("https://reco.birdnet.tucmi.de/reco")
#'
#' @importFrom dplyr rename mutate arrange
#' @importFrom lubridate ymd_hms
get_detections <- function(url, params = NULL) {
  api_response <-
    perform_get_request(url, "det", params)

  api_data <-
    api_response |>
    resp_body_json_to_df()
  # test if all columns are there
  all_cols <- length(api_data) == length(expected_detections_response)

  # test variable names
  all_names <- all(names(api_data) %in% names(expected_detections_response))

  # test classes of variables
  classes_api_data <- sapply(api_data, class)
  classes_expected <- sapply(expected_detections_response, class)
  all_classes <-  all(classes_api_data == classes_expected)

  if (all(all_cols, all_names, all_classes)) {
    dats <-
      api_data |>
      rename(recorder_id = recorder_id_id) |>
      mutate(
        datetime = lubridate::ymd_hms(datetime),
        start = as.numeric(start),
        end = as.numeric(end),
        confidence = as.numeric(confidence),
        lat = as.numeric(lat),
        lon = as.numeric(lon)
      ) %>%
      arrange(datetime)
    return(dats)
  } else {
    warning("Response data didnt match expected response")
    expected_detections_response |>
      rename(recorder_id = recorder_id_id)
  }
}

expected_detections_response <-
  data.frame(
    uid = character(0),
    recorder_id_id = character(0),
    datetime = character(0),
    start = numeric(0),
    end = numeric(0),
    species_code = character(0),
    confidence = numeric(0),
    confirmed = logical(0),
    species_code_annotated = character(0),
    lat = numeric(0),
    lon = numeric(0),
    snippet_path = character(0)
  )




#' Retrieve log data from a given URL
#'
#' @param url The URL of the API
#' @param params Parameters to GET request as list. Can include Django field lookups
#' @return A dataframe containing log data.
#' @export
#'
#' @examples
#' params <- list(
#'   "recorder_nr_id" = "BirdNET-HI111",
#'   "datetime_pi__gte" = "2023-01-17"
#' )
#' get_log("https://reco.birdnet.tucmi.de/reco", params)
#'
#' @importFrom lubridate ymd_hms
#' @importFrom dplyr mutate rename arrange
get_log <- function(url, params = NULL) {
  api_response <-
    perform_get_request(url, "log", params)

  api_data <-
    api_response %>%
    resp_body_json_to_df() |>
    rename(recorder_id = recorder_nr_id) %>%
    mutate(datetime_pi = lubridate::ymd_hms(datetime_pi)) %>%
    arrange(datetime_pi)

  return(api_data)
}


#' Retrieve recorder configs from a given URL
#'
#' @param url The URL of the API
#' @param params Parameters to GET request as list. Can include Django field lookups
#'
#' @return Dataframe.
#' @export
#'
#' @examples
#' #' params <- list(
#'   "recorder_id" = "BirdNET-HI001"
#' )
#' get_recorders("https://reco.birdnet.tucmi.de/reco", params)
get_recorders <- function(url, params = NULL) {
  api_response <-
    perform_get_request(url, "rec", params)

  api_response %>%
    resp_body_json_to_df()
}
