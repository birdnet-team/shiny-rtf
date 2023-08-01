#' status_overview UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import leaflet
#' @import echarts4r
mod_status_overview_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      div(
        class = "indented-heading",
        h4("Status of recorders")
      )
    ),
    fluidRow(
        column(
          6,
          # div(
          #   class = "headless-box",
          #   box(
          #     width = NULL,
          #     collapsible = FALSE,
          #     headerBorder = FALSE,
          #     elevation = 1,
          #     div(
          #       style = "height: 25vh",
                uiOutput(ns("status_boxes"))
          #     )
          #   )
          # )
        ),
      column(
        6,
          shinyWidgets::panel(
            div(
              style = "height: 25vh",
              leafletOutput(ns("map"), width = "100%", height = "100%")
            )
          )
      )
    ),
    fluidRow(
      h4(" "),
      div(
        class = "indented-heading",
        h4("Activity")
      )
    ),
    fluidRow(
      column(
        6,
        shinyWidgets::panel(
          div(
            style = "height:45vh; overflow: auto;",
            reactableOutput(ns("table_n_max_species"), width = "100%", height = "100%")
          ),
          footer = "Detections per recorder and species in selected time range.",
        )
        # div(
        #   class = "headless-box",
        #   box(
        #     footer = "Detections per recorder and species in selected time range.",
        #     width = NULL,
        #     collapsible = FALSE,
        #     headerBorder = FALSE,
        #     elevation = 1,
        #     div(
        #       style = "height:45vh; overflow: auto;",
        #       reactableOutput(ns("table_n_max_species"), width = "100%", height = "100%")
        #     )
        #   )
        # )
      ),
      column(
        6,
        shinyWidgets::panel(
              div(
                style = "height:45vh",
                echarts4rOutput(ns("bubble_timeline"), width = "100%", height = "100%")
              ),
          footer = "Detections per hour.\nCircle sizes are scaled within species and are not comparable between species."
        )
        # div(
        #   class = "headless-box",
        #   box(
        #     footer = "Detections per hour.\nCircle sizes are scaled within species and are not comparable between species.",
        #     width = NULL,
        #     collapsible = FALSE,
        #     headerBorder = FALSE,
        #     elevation = 1,
        #     div(
        #       style = "height:45vh",
        #       echarts4rOutput(ns("bubble_timeline"), width = "100%", height = "100%")
        #     )
        #   )
        # )
      )
    )
  )
}

#' status_overview Server Functions
#'
#' @noRd
mod_status_overview_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns


    # Functions -------------------------------------------------------------------------------------------------------

    new_job_freq <- function(datetime_vec, task_vec, task, unit, now = FALSE) {
      dt_vec <- datetime_vec[task_vec == task]
      if (now) {
        end <- lubridate::now(tzone = lubridate::tz(dt_vec[1]))
      } else {
        end <- max(dt_vec)
      }
      duration_h <- interval(min(dt_vec), end) %>% as.numeric(unit)
      return(length(dt_vec) / duration_h)
    }

    my_infobox <- function(status_message, recorder_id, status_icon, status, status_color, last_event, time_since_last_job, ...) {
      bs4Dash::infoBox(
        width = NULL,
        title = status_message,
        value = recorder_id,
        subtitle = p(
          "Last event",
          round(time_since_last_job, 0),
          "minutes ago",
          br(),
          strftime(last_event, "%a %b %e, %H:%M ", usetz = TRUE, tz = lubridate::tz(last_event)),
        ),
        color = status,
        icon = icon(status_icon),
        elevation = 1,
        iconElevation = 1
      )
    }

    # Data ------------------------------------------------------------------------------------------------------------

    log_summary <- reactive({
      req(nrow(data$logs) > 0)
      data$logs %>%
        group_by(recorder_id) %>%
        arrange(desc(datetime_pi)) %>%
        summarise(
          last_event = dplyr::first(datetime_pi),
          free_disk = dplyr::first(free_disk),
          n_errors = sum(error != ""),
          freq_jobs = new_job_freq(datetime_pi, task, "start new job", "hour", FALSE)
        ) %>%
        mutate(
          time_since_last_job = lubridate::interval(
            last_event,
            lubridate::now(tzone = lubridate::tz(last_event))
          ) %>%
            as.numeric("minutes")
        ) %>%
        mutate(
          status = case_when(
            time_since_last_job < 30 ~ "success",
            between(time_since_last_job, 30, 60) ~ "warning",
            time_since_last_job > 60 ~ "danger",
          ),
          status_color = case_when(
            status == "success" ~ "#198754",
            status == "warning" ~ "#ffc107",
            status == "danger" ~ "#dc3545",
          ),
          status_message = case_when(
            status == "success" ~ "online",
            status == "warning" ~ "last job more than 30 minutes ago!",
            status == "danger" ~ "last job more than 1 hour ago!",
          ),
          status_icon = case_when(
            status == "success" ~ "check-circle",
            status == "warning" ~ "exclamation-circle",
            status == "danger" ~ "x-circle",
          )
        )
    })

    recorders <- reactive({
      req(data$recorders)
      req(log_summary())
      data$recorders %>%
        left_join(log_summary()) %>%
        select(lat, lon, recorder_id, status_color)
    })

    table_dats <- reactive({
      req(data$detections)
      data$detections %>%
        dplyr::count(recorder_id, common) %>%
        #dplyr::slice_max(n, n = 10, by = recorder_id) %>%
        tidyr::pivot_wider(names_from = recorder_id, values_from = n, values_fill = 0) %>%
        tibble::column_to_rownames("common")
    })

    bubble_timeline_dats <- reactive({
      req(data$detections)
      data$detections %>%
        mutate(agg_timeunit = lubridate::floor_date(datetime, unit = "10 min")) %>%
        count(common, agg_timeunit) %>%
        tidyr::complete(common, agg_timeunit = seq(min(agg_timeunit), max(agg_timeunit), by = "10 min"), fill = list(n = 0L)) %>%
        mutate(common = stringr::str_replace(common, " ", "\n"))
      # %>%
      # group_by(commonn) %>%
      # mutate(total = sum(n)) %>%
      # ungroup() %>%
      # mutate(prop = signif((n / total), 1))
    })


    # Render Functions ------------------------------------------------------------------------------------------------

    output$status_boxes <- renderUI({
      bs4Dash::boxLayout(
        type = "deck",
        purrr::pmap(log_summary(), my_infobox)
      )
    })

    output$map <- renderLeaflet({
      req(recorders())
      leaflet(
        recorders()
      ) %>%
        addTiles(group = "OpenStreetMap") %>%
        addProviderTiles("Esri.WorldImagery", group = "Satellit") %>%
        addLayersControl(
          baseGroups = c("OpenStreetMap", "Satellit"),
          position = "topleft",
          options = layersControlOptions(collapsed = TRUE)
        ) %>%
        addCircleMarkers(
          color = ~status_color,
          fillOpacity = 0.8,
          label = ~recorder_id,
          labelOptions = labelOptions(
            sticky = FALSE,
            direction = "bottom",
            offset = c(0, 10)
          )
        )
    })

    output$table_n_max_species <- renderReactable({
      req(ncol(table_dats()) > 0)
      table_dats() %>%
      reactable::reactable(
          compact = TRUE,
          borderless = TRUE,
          pagination = FALSE,
          sortable = TRUE,
          showSortable = TRUE,
          defaultColDef = colDef(
            defaultSortOrder = "desc",
            align = "left",
            cell = reactablefmtr::data_bars(
              data = .,
              fill_color = viridis::mako(1000),
              background = "#ffffff",
              # round_edges = TRUE,
              # min_value = 0,
              # max_value = 10000,
              text_position = "outside-end",
              number_fmt = scales::comma
            )
          ),
          columns = list(
            .rownames = colDef(name = "Species", sortable  = TRUE)
          )
        )
    })

    output$bubble_timeline <- renderEcharts4r({
      req(nrow(bubble_timeline_dats()) > 0)

      bubble_timeline_dats() %>%
        group_by(common) %>%
        e_charts(
          agg_timeunit,
          height = "100%",
          width = "100%"
          ) %>%
        #e_line(common, legend = FALSE, symbol = "none", lineStyle = list(width = 0.5, color = "lightgrey", opacity = 0.4)) %>%
        e_scatter(common, size = n, legend = FALSE, scale = \(x)scales::rescale(x, to = c(1,30))) %>%
        e_x_axis(
          name = "",
          type = "time",
          axisLabel = list(
            fontSize = '0.9rem',
            color = "#212529",
            fontFamily = "Arial",
            fontWeight = 400
          )
          ) %>%
        e_y_axis(
          name = "",
          type = "category",
          #margin = 10,
          offset = 16,
          inverse = TRUE,
          axisLabel = list(
            #width = 200,
            #padding = 16,
            overflow = "truncate",
            hideOverlap = FALSE,
            showMinLabel = TRUE,
            showMaxLabel = TRUE,
            align = "right",
            fontSize = '0.9rem',
            color = "#212529",
            #fontFamily = "Arial",
            fontWeight = 400
          ),
          axisTick = list(alignWithLabel = TRUE),
          axisLIne = list(
            onZero = FALSE
          )
        ) %>%
        e_tooltip(formatter = htmlwidgets::JS("
              function(params){
                return('<strong>' + params.name + '</strong>' +
                        '<br />' + 'Detections: ' + params.value[2] +
                        '<br />' + 'Datetime: ' + params.value[0]
                )
              }
          ")
        ) %>%
        e_grid(containLabel = TRUE, left = '2%', top = '10%', right = "5%") %>%
        e_toolbox(show = FALSE) %>%
        e_datazoom(type = "slider", xAxisIndex = 0, start = 100, end = 0, brushSelect = FALSE, height = 20) %>%
        #e_datazoom(type = "inside", yAxisIndex = 0, start = 1, end = 15, zoomLock = TRUE, moveOnMouseWheel = TRUE) %>%
        e_datazoom(type = "slider", yAxisIndex = 0, start = 0, end = 25, zoomLock = FALSE, brushSelect = FALSE, width = 20)

    })
  })
}

## To be copied in the UI
# mod_status_overview_ui("status_overview_1")

## To be copied in the server
# mod_status_overview_server("status_overview_1")
