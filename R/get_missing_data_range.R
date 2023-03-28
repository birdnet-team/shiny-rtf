local_data <- landing_data$detections
params <-  list("datetime_gte" = "2023-03-10", "datetime__lte" = "2023-03-20")

get_missing_data_range(local_data, params)

get_missing_data_range <- function(local_data, params) {
  # Check if columns in params are present in local data
  for (col_name in names(params)) {
    col <- strsplit(col_name, "__")[[1]][1]
    if (!(col %in% names(local_data))) {
      stop(paste("Column", col, "not found in local data"))
    }
  }
  # Check which parts of the data are already available locally
  available_range <- list()
  # Split column name and suffix
  col_parts <- lapply(names(params), function(col_name) {
    strsplit(col_name, "__")[[1]]
  })
  for (i in seq_along(col_parts)) {
    col <- col_parts[[i]][1]
    suffix <- ifelse(length(col_parts[[i]]) > 1, col_parts[[i]][2], NULL)
    # Get the available range for the column
    col_data <- local_data[[col]]
    if (is.numeric(col_data)) {
      available_range[[names(params)[i]]] <- range(col_data, na.rm = TRUE)
    } else {
      available_range[[names(params)[i]]] <- unique(col_data)
    }
    # Generate the desired range for the column
    if (!is.null(suffix)) {
      if (suffix %in% c("gte", "let", "gt", "lt", "eq")) {
        desired_range <- as.numeric(substr(suffix, 4, nchar(suffix)))
        if (suffix %in% c("gte", "let")) {
          if (suffix == "gte") {
            desired_range <- c(desired_range, Inf)
          } else {
            desired_range <- c(-Inf, desired_range)
          }
        }
      } else if (suffix == "in") {
        desired_range <- as.numeric(strsplit(col_parts[[i]][2], "__")[[1]])
      } else {
        stop(paste("Invalid suffix", suffix, "for column", names(params)[i]))
      }
    } else {
      desired_range <- NULL
    }
    # Compare the available and desired range
    if (!is.null(desired_range)) {
      if (is.numeric(available_range[[names(params)[i]]])) {
        if (desired_range[1] > available_range[[names(params)[i]]][2] || desired_range[2] < available_range[[names(params)[i]]][1]) {
          return(paste(col, paste(suffix, desired_range, sep = "__"), sep = "__"))
        }
      } else {
        if (!all(desired_range %in% available_range[[names(params)[i]]])) {
          return(paste(col, paste(suffix, desired_range, sep = "__"), sep = "__"))
        }
      }
    }
  }
  return(NULL)
}
