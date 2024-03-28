#' phenology UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import suncalc
#' @import echarts4r
#' @import waiter
mod_phenology_ui <- function(id) {
  ns <- NS(id)
  tagList(
    waiter::use_waiter(),
    fluidRow(column(
      6,
      shinyWidgets::panel(
        fluidRow(
          column(
            3,
            selectizeInput(
              ns("species_filter"),
              label = "Species",
              choices = c("Choose" = "", sort(birdnames$common))
            )
          ),
          column(1),
          column(
            3,
            shinyWidgets::pickerInput(
              ns("recorder_filter"),
              label = "Recorder",
              choices = c("None available" = ""),
              multiple = TRUE,
              options = pickerOptions(
                style = "btn-default"
              )
            )
          ),
          column(1),
          column(
            3,
            sliderInput(
              ns("confidence"),
              label = "Confidence",
              min = 0.1,
              max = 1,
              step = 0.1,
              value = c(0.1, 1)
            )
          )
        )
      )
    )),
    fluidRow(column(
      8,
      shinyWidgets::panel(
        div(
          id = ns("phenology_plot_div"),
          style = "height:70vh",
          echarts4rOutput(
            ns("phenology_plot"),
            width = "100%", height = "100%"
          )
        ),
        footer = "Number of detections per 10 minuten interval. Lines depict sunset and sunrise."
      )
    ))
  )
}

#' phenology Server Functions
#'
#' @noRd
#' @import waiter
mod_phenology_server <- function(id, data, url) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # update the recorder selecter
    observe({
      req(data$recorders$recorder_id)
      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "recorder_filter",
        choices = data$recorders$recorder_id,
        selected = data$recorders$recorder_id
      )
    })


    input_confidence_d <- reactive({
      input$confidence
    }) |> debounce(500)

    input_recorder_d <- reactive({
      input$recorder_filter
    }) |> debounce(500)

    # download
    detections <- reactive({
      req(input$species_filter)

      waiter::waiter_show(
        id = c(ns("phenology_plot_div")),
        html = tagList(
          waiter::spin_loaders(15, color = "gray")
        ),
        color = waiter::transparent(.5)
      )

      selected_species_code <-
        birdnames$code[birdnames$common == input$species_filter]
      golem::print_dev(selected_species_code)
      golem::print_dev(data$recorders$recorder_id)

      params <-
        list("species_code" = selected_species_code)
      dets <- lapply(data$recorders$recorder_id, function(x) {
        get_detections(url, params = c(params, "recorder_id" = x))
      }) |> do.call(what = rbind, args = _)

      waiter::waiter_hide(id = ns("phenology_plot_div"))
      return(dets)
    }) |>
      bindCache(input$species_filter) |>
      bindEvent(input$species_filter)

    observe({
      golem::message_dev("DOWNLOADED DATA IN PHENOLOGY")
      golem::print_dev(glimpse(detections()))
    })

    # aggregate detections into intervals
    calendar_dats <- reactive({
      req(detections()) |>
        dplyr::filter(
          dplyr::between(confidence, min(input_confidence_d()), max(input_confidence_d())),
          recorder_id %in% input_recorder_d()
        ) |>
        mutate(
          datetime = lubridate::force_tz(datetime, "US/Hawaii"),
          datetime_call = datetime + lubridate::seconds(start),
          agg_timeunit = lubridate::floor_date(datetime_call, unit = "10 mins")
        ) |>
        count(agg_timeunit) |>
        # fill in "time slots" that are missing in the sequence by recorder
        tidyr::complete(
          agg_timeunit = seq(
            lubridate::floor_date(min(agg_timeunit), unit = "day") - days(3), # ymd_hms("2023-01-01 00:00:00"),
            lubridate::ceiling_date(max(agg_timeunit), unit = "day") + days(3), # ymd_hms("2023-12-31 23:59:59"),
            by = "10 min"
          ),
          fill = list(n = 0L)
        ) |>
        mutate(
          date = lubridate::date(agg_timeunit),
          time = hms::as_hms(agg_timeunit),
          time_seconds = difftime(agg_timeunit, date, units = "secs") |> as.numeric()
        )
    })

    # calculate sunset/sunrise for data interval
    # unfortunately suncalc has a bug see https://github.com/datastorm-open/suncalc/issues/2
    # Time is correct but 1 day must be added
    suntimes <- reactive({
      suncalc::getSunlightTimes(
        date = unique(calendar_dats()$date),
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
          time_sunrise_seconds = difftime(sunrise, date, units = "secs") |> as.numeric(),
          time_sunset_seconds = difftime(sunset, date, units = "secs") |> as.numeric()
        )
    })

    output$phenology_plot <- renderEcharts4r({
      calendar_dats() |>
        mutate(n = if_else(n == 0, NA, n)) |>
        e_charts(date) |>
        e_heatmap(time, n, emphasis = list(disabled = TRUE), progressive = 0, animation = FALSE) |>
        e_visual_map(
          n,
          type = "continuous",
          calculable = FALSE,
          color = rev(c("#fcde9c", "#faa476", "#f0746e", "#e34f6f", "#dc3977", "#b9257a", "#7c1d6f")),
          left = "right",
          top = "bottom"
        ) |>
        e_tooltip(formatter = htmlwidgets::JS("
              function(params){
                return('<strong>' + params.name + '</strong>' +
                        '<br />' + 'Time: ' + params.value[1] +
                        '<br />Detections: ' + params.value[2]
                )
              }
        ")) |>
        e_data(suntimes(), date) |>
        e_line(time_sunset_seconds, symbol = "none", legend = FALSE, y_index = 1, x_index = 0, animation = FALSE) |>
        e_line(time_sunrise_seconds, symbol = "none", legend = FALSE, y_index = 1, x_index = 0, animation = FALSE) |>
        e_y_axis(index = 0, type = "category") |>
        e_y_axis(index = 1, type = "value", min = 0, max = 24 * 60 * 60, show = FALSE) |>
        e_x_axis(index = 0, offset = 5, type = "category", margin = 5) |>
        e_datazoom(type = "slider", xAxisIndex = 0, start = 100, end = 0, brushSelect = FALSE, height = 20, toolbox = TRUE, left = "5%") %>%
        e_grid(
          containLabel = TRUE,
          left = "left",
          top = "middel"
        ) |>
        identity()
    })
  })
}

## To be copied in the UI
# mod_phenology_ui("phenology_1")

## To be copied in the server
# mod_phenology_server("phenology_1")
