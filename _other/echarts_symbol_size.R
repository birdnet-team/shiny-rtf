#' Scale the size of symbols in an echarts4r object
#'
#' @param e An echarts4r object
#' @param width The width of the symbols. Either a numeric value or the name of a column in the data.
#' @param height The height of the symbols. Either a numeric value or the name of a column in the data.
#' @return An echarts4r object with the sizes of the symbols modified
#' @example
#'
#' iris |>
#'  dplyr::group_by(Species) |>
#'  dplyr::mutate(
#'    symbol_width = e_scale(Sepal.Width),
#'    symbol_height = e_scale(Sepal.Length)
#'  ) |>
#'  e_charts_("Sepal.Width") |>
#'  e_scatter_(
#'    "Sepal.Length",
#'    symbol = "rect"
#'  ) |>
#'  e_scale_symbol_size("symbol_width", "symbol_height") |>
#'  e_x_axis(min = 1.5) |>
#'  e_y_axis(min = 4)

e_scale_symbol_size <- function(e, width = 3, height = 3) {
  # Check if 'e' is an echarts4r object
  if (!inherits(e, "echarts4r")) {
    stop("e must be an echarts4r object.")
  }

  # Get the number of series
  n_series <- length(e$x$data)

  # Iterate over each series
  for (i in seq_len(n_series)) {
    n_data <- length(e$x$opts$series[[i]]$data)

    # Check if 'width' and 'height' are numeric or existing column names
    if (is.numeric(width)) {
      width_vals <- rep(width, n_data)
    } else if (!width %in% names(e$x$data[[i]])) {
      stop(paste("The width column", width, "does not exist in the data."))
    } else {
      width_vals <- e$x$data[[i]][[width]]
    }

    if (is.numeric(height)) {
      height_vals <- rep(height, n_data)
    } else if (!height %in% names(e$x$data[[i]])) {
      stop(paste("The height column", height, "does not exist in the data."))
    } else {
      height_vals <- e$x$data[[i]][[height]]
    }

    # Modify the size of each symbol
    for (k in seq_len(n_data)) {
      e$x$opts$series[[i]]$data[[k]]$symbolSize <-
        c(width_vals[k], height_vals[k])
    }
  }

  # Return the modified echarts4r object
  return(e)
}

iris |>
  dplyr::group_by(Species) |>
  dplyr::mutate(
    symbol_width = e_scale(Sepal.Width),
    symbol_height = e_scale(Sepal.Length)
  ) |>
  e_charts_("Sepal.Width") |>
  e_scatter_("Sepal.Length", size = Sepal.Width, symbol = "rect") |>
  #e_scale_symbol_size("symbol_width", "symbol_height") |>
  e_x_axis(min = 1.5) |>
  e_y_axis(min = 4)
