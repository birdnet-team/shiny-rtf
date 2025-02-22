library(httr2)
library(purrr)
library(dplyr)
library(echarts4r)
library(suncalc)
library(lubridate)

source("R/fcts_get_api.R")

url <- "https://reco.birdnet.tucmi.de/reco"

# REcorders -------------------------------------------------------------------------------------------------------
params <- list("recorder_id" = "BirdNET-HI001")
recorders <- get_recorders(url = url, params = params)

recorders <- get_recorders(url = url)


# Detections ------------------------------------------------------------------------------------------------------

# species <- c("hawama")
species <- "houfin"
# params <- list("datetime__gte" = "2023-07-28", "species_code" = species, "recorder_id" = recorders$recorder_id[1])
# get_detections(url, params = params)

paramas <- list("datetime__gte" = "2023-01-01", "species_code" = species, "confidence__gte" = 0.1 )
dets <- lapply(recorders$recorder_id, function(x) {
  #print(c(params, "recorder_id" = x))
  get_detections(url, params = c(paramas, "recorder_id" = x))
}) |> do.call(what = rbind, args = _)
#
#dets <- get_detections(url, params = c("datetime__gte" = "2023-08-31", "recorder_id" = "BirdNET-HI001"))
#
# length(dets) == length(expected_detections_response)
#
# all(names(dets) == names(expected_detections_response))
#
# classes_dets <- sapply(dets, class)
# classes_expected <- sapply(expected_detections_response, class)
#
# all(classes_dets == classes_expected)

calendar_dats <-
  dets |>
  #filter(confidence > 0.8) |>
  mutate(
    datetime = lubridate::force_tz(datetime, "US/Hawaii"),
    datetime_call = datetime + lubridate::seconds(start),
    agg_timeunit = lubridate::floor_date(datetime_call, unit = "10 mins")
  ) |>
  count(agg_timeunit) |>
  # fill in "time slots" that are missing in the sequence by recorder
  tidyr::complete(agg_timeunit = seq(
    lubridate::floor_date(min(agg_timeunit), unit = "day") - days(3), #ymd_hms("2023-01-01 00:00:00"),
    lubridate::ceiling_date(max(agg_timeunit), unit = "day") + days(3), # ymd_hms("2023-12-31 23:59:59"),
    by = "10 min"
  ),
  fill = list(n = 0L)) |>
  mutate(
    date = lubridate::date(agg_timeunit),
    time = hms::as_hms(agg_timeunit),
    time_seconds = difftime(agg_timeunit, date, units = "secs") |> as.numeric()
  )



# unfortunately suncalc has a bug see https://github.com/datastorm-open/suncalc/issues/2
# Time is correct but 1 day must be added
suntimes <-
  getSunlightTimes(
    date = unique(calendar_dats$date),
    lat = 19.8,
    lon = -156,
    tz = "US/Hawaii",
    keep = c("sunrise", "sunset", "night")
  ) |>
  tibble::as_tibble() |>
  # because bug, we only use the correct time from sunrise/sunset
  mutate(across(where(lubridate::is.POSIXct), ~ lubridate::ymd_hms(paste(
    date, hms::as_hms(.x)
  )))) |>
  mutate(
    time_sunrise = hms::as_hms(sunrise),
    time_sunset = hms::as_hms(sunset),
    time_sunrise_rounded = lubridate::round_date(sunrise, unit = "10 mins") |> hms::as_hms(),
    time_sunset_rounded = lubridate::round_date(sunset, unit = "10 mins") |> hms::as_hms(),
    time_sunrise_seconds = difftime(sunrise, date, units = "secs") |> as.numeric(),
    time_sunset_seconds = difftime(sunset, date, units = "secs") |> as.numeric()
  )


# heatmap_suntimes <-
#   calendar_dats |>
#   left_join(suntimes) |>
#   #select(date, time, time_seconds, n, time_sunrise_rounded, time_sunset_rounded) |>
#   distinct()
#
# heatmap_suntimes |>
#   filter(date > "2023-10-30") |> View()
calendar_dats |>
  mutate(n = if_else(n == 0, NA, n)) |>
  e_charts(date) |>
  e_heatmap(time, n, emphasis = list(disabled = TRUE)) |>
  e_visual_map(
    n,
    type = "continuous",
    calculable = FALSE,
    color = rev(c("#fcde9c", "#faa476", "#f0746e", "#e34f6f", "#dc3977", "#b9257a", "#7c1d6f")),
    right = "1%",
    bottom = "2%"
  ) |>
  e_tooltip(formatter = htmlwidgets::JS("
              function(params){
                return('<strong>' + params.name + '</strong>' +
                        '<br />' + 'Time: ' + params.value[1] +
                        '<br />Detections: ' + params.value[2]
                )
              }
        ")) |>
  e_data(suntimes, date) |>
  e_line(time_sunset_seconds, symbol = "none", legend = FALSE, y_index = 1, x_index = 1) |>
  e_line(time_sunrise_seconds, symbol = "none", legend = FALSE, y_index = 1, x_index = 1) |>
  e_y_axis(index = 0, type = "category") |>
  e_y_axis(index = 1, type = "value", min = 0, max = 24 * 60 * 60, show = FALSE) |>
  e_x_axis(index = 0, offset = 5, type = "category", margin = 5) |>
  e_x_axis(index = 1, offset = 5, type = "time", margin = 5, show = FALSE) |>
  e_grid(
    containLabel = TRUE,
    left = "left",
    top = "middel",
    bottom = "2%",
    right = "5%"
  ) |>
  # e_datazoom(type = "slider", xAxisIndex = 1, start = 100, end = 0, brushSelect = FALSE, height = 20) %>%
  identity()


calendar_dats |>
  mutate(n = if_else(n == 0, NA, n)) |>
  e_charts(date) |>
  e_heatmap(time, n, emphasis = list(disabled = TRUE)) |>
  e_visual_map(
    n,
    type = "continuous",
    min = 0,
    max = 10,
    calculable = FALSE,
    color = rev(c("#fcde9c","#faa476","#f0746e","#e34f6f","#dc3977","#b9257a","#7c1d6f")),
    position = "insideBottomRight"
  ) |>
  e_tooltip(formatter = htmlwidgets::JS("
              function(params){
                return('<strong>' + params.name + '</strong>' +
                        '<br />detections: ' + params.value[2] +
                        '<br />' + 'Date: ' + params.value[0] +
                        '<br />' + 'Time: ' + params.value[1]
                )
              }
    ")) |>
  e_data(suntimes, date) |>
  e_line(time_sunset_seconds, symbol = "none", legend = FALSE, y_index = 1, x_index = 0) |>
  e_line(time_sunrise_seconds, symbol = "none", legend = FALSE, y_index = 1, x_index = 0) |>
  e_y_axis(index = 0, type = "category") |>
  e_y_axis(index = 1, type = "value", min = 0, max = 24 * 60 * 60, show = TRUE) |>
  e_x_axis(index = 0, offset = 5, type = "category", margin = 5) |>
  e_datazoom(type = "slider", xAxisIndex = 0, start = 100, end = 0, brushSelect = TRUE, height = 20) %>%
  #e_datazoom(type = "inside") |>
  identity()




# e_formatter_seconds_to_hhmmss <- function() {
#   htmlwidgets::JS(
#       "function(value, index) {
#         var timestamp = new Date(value * 1000).toISOString().substring(11, 16);
#         return timestamp;
#     }"
#   )
# }
