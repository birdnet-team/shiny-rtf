#' download_png
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
download_png <- function(url) {
  # Create a temporary file
  temp_file <- tempfile(fileext = ".png")

  # Try to download the file
  tryCatch({
    download.file(url, destfile = temp_file, mode = "wb")
    if (file.exists(temp_file)) {
      return(list(value = temp_file, success = TRUE))
    }
  }, error = function(e) {
    # Handle errors
    return(list(value = e$message, success = FALSE))
  })
}
