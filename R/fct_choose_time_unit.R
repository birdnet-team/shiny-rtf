#' Choose Time Unit
#'
#' Automatically choose an appropriate time unit based on the range of values in a time vector.
#'
#' @param time_vector A vector containing time values.
#' @param num_units The desired number of units.
#' @param possible_units A named numeric vector containing possible time units to choose from.
#'
#' @return A character string indicating the name of the chosen time unit.
#'
#' @details This function calculates the length of the time interval in hours based on the range of values in the \code{time_vector} argument. It then calculates the ratio of the desired number of units to the length of the time interval for each possible time unit in the \code{possible_units} argument. The function selects the time unit that has the closest ratio to 1 and returns its name.
#'
#' Note that the values in the \code{possible_units} vector should be in hours, and the names should correspond to valid time units that can be used with the \code{floor_date()} function in the \code{lubridate} package. If \code{lubridate} is not installed, only units in hours can be used.
#'
#' @examples
#' time_vector <- as.POSIXct(c("2022-02-01 12:00:00", "2022-02-15 18:00:00", "2022-03-01 00:00:00"))
#' possible_units <- c(`24 hours` = 24, `7 days` = 168, `1 month` = 720) # Corresponding values are in hours
#' choose_time_unit(time_vector, 2, possible_units)
#'
#' @importFrom base difftime
#' @export
#' @author Your Name Here
#' @seealso \code{\link[base]{difftime}}, \code{\link[lubridate]{floor_date}}
choose_time_unit <- function(time_vector, num_units, possible_units) {

  # Calculate the length of the time interval in hours
  interval_hours <- as.numeric(difftime(max(time_vector), min(time_vector), units = "hours"))

  # Calculate the ratio of desired units to interval length for each possible unit
  unit_ratios <- num_units / (interval_hours / possible_units)

  # Find the index of the unit with the closest ratio to 1
  closest_unit_index <- which.min(abs(unit_ratios - 1))

  # Return the name of the unit with the closest ratio
  return(names(possible_units)[closest_unit_index])
}
