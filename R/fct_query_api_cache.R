#' Query and cache API data with specified parameters
#'
#' This function queries an API endpoint for data with specified parameters,
#' and caches the data locally for future use. If the data is already available
#' locally, the function returns the subset of the data that matches the specified
#' parameters. If the data is partially available locally, the function downloads
#' only the missing data to complete the range specified by the parameters.
#'
#' @param species character vector specifying the species to query
#' @param datetime_min minimum datetime value to query (YYYY-MM-DD format)
#' @param datetime_max maximum datetime value to query (YYYY-MM-DD format)
#' @param confidence_min minimum confidence value to query (numeric)
#' @param confidence_max maximum confidence value to query (numeric)
#' @param cache_env environment object where the cached data should be stored
#'
#' @return a data.frame containing the queried data
#' @export
#' @examples
#' cached_data <- new.env()
#' query_api_cache(species = 'dog', datetime_min = '2022-01-01', datetime_max = '2022-02-01', confidence_min = 0.8, confidence_max = 0.9, cache_env = cached_data)

query_api_cache <- function(species = NULL, datetime_min = NULL, datetime_max = NULL, confidence_min = NULL, confidence_max = NULL, cache_env = NULL) {
  # check if cache_env is NULL or not, and create a new environment if necessary
  if (is.null(cache_env)) {
    cache_env <- new.env()
  }

  # check which parts of the data are already available locally
  local_data <- NULL
  if (exists("local_data", envir = cache_env)) {
    local_data <- get("local_data", envir = cache_env)
  }
  if (!is.null(local_data)) {
    local_data <- subset(local_data, species == species)
    available_datetime_min <- min(local_data$datetime)
    available_datetime_max <- max(local_data$datetime)
    available_confidence_min <- min(local_data$confidence)
    available_confidence_max <- max(local_data$confidence)
  } else {
    available_datetime_min <- NULL
    available_datetime_max <- NULL
    available_confidence_min <- NULL
    available_confidence_max <- NULL
  }

  # generate new parameters that specify the missing range of data
  if (!is.null(datetime_min) && !is.null(datetime_max)) {
    if (!is.null(available_datetime_min) && !is.null(available_datetime_max)) {
      datetime_min <- max(datetime_min, available_datetime_min)
      datetime_max <- min(datetime_max, available_datetime_max)
      if (datetime_min > datetime_max) {
        message("No data found in datetime range.")
        return(NULL)
      }
    }
  }
  if (!is.null(confidence_min) && !is.null(confidence_max)) {
    if (!is.null(available_confidence_min) && !is.null(available_confidence_max)) {
      confidence_min <- max(confidence_min, available_confidence_min)
      confidence_max <- min(confidence_max, available_confidence_max)
      if (confidence_min > confidence_max) {
        message("No data found in confidence range.")
        return(NULL)
      }
    }
  }

  # download the missing data using get_api_data() function
  if (is.null(datetime_min) && is.null(datetime_max) && is.null(confidence_min) && is.null(confidence_max)) {
    message("Downloading all data...")
    missing_data <- get_api_data(species = species)
  } else {
    message(paste0("Downloading missing data with species = ", species))
    if (!is.null(datetime_min) && !is.null(datetime_max)) {
      message(paste0(", datetime between ", datetime_min, " and ", datetime_max))
    }
    if (!is.null(confidence_min) && !is.null(confidence_max)) {
      message(paste0(", confidence between ", confidence_min, " and ", confidence_max))
    }
    message("...")
    missing_data <- get_api_data(species = species, datetime_min = datetime_min, datetime_max = datetime_max, confidence_min = confidence_min, confidence_max = confidence_max)
  }

  # combine the local data and the missing data, and store it in the cache
  new_data <- missing_data
  if (!is.null(local_data) && nrow(local_data) > 0) {
    new_data <- rbind(local_data, missing_data)
  }
  assign("local_data", new_data, envir = cache_env)

  return(new_data)
}

