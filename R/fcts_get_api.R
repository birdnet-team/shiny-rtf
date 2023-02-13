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
    req_url_path_append(path) |>
    (\(.) {
      if (is.null(params)) {
        .
      } else {
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
    tibble::as_tibble()
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
    resp_body_json_to_df() |>
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

  return(api_data)
}



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


#get_audio <- function(url, params = NULL) {
#  api_response %>%
#  response(status_code = 200, url = "", method = GET, headers = list(), body = raw())

#return (FileResponse(open(filepath, 'rb'), filename=filename))
#}





