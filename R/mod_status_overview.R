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
mod_status_overview_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(6, uiOutput(ns("status_boxes"))),
      column(
        6,
        box(
          width = NULL,
          collapsible = FALSE,
          headerBorder = FALSE,
          elevation = 1,
          leafletOutput(ns("map")))
      )
    ),
    fluidRow(
      column(6, box(
        width = NULL,
        collapsible = FALSE,
        headerBorder = FALSE,
        elevation = 1,
        reactableOutput(ns("table_n_max_species"))
      ))
    )
  )
}

#' status_overview Server Functions
#'
#' @noRd
mod_status_overview_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    new_job_freq <- function(datetime_vec, task_vec, task, unit, now = FALSE) {
      dt_vec <- datetime_vec[task_vec == task]
      if (now) {
        end <- lubridate::now(tz = lubridate::tz(dt_vec[1]))
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
          round(time_since_last_job, 0), "minutes ago",
          br(),
          strftime(last_event, "%a %b %e, %H:%M ", usetz = TRUE, tz = lubridate::tz(last_event)),
        ),
        color = status,
        icon = icon(status_icon),
        elevation = 1,
        iconElevation = 1
      )
    }

    log_summary <- reactive({
      req(data$logs)
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
            lubridate::now(tz = lubridate::tz(last_event))
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
      req(log_summary)
      data$recorders %>%
        left_join(log_summary()) %>%
        select(lat, lon, recorder_id, status_color)
    })

    output$status_boxes <- renderUI({
      bs4Dash::boxLayout(
        type = "deck",
        purrr::pmap(log_summary(), my_infobox)
      )
    })

    output$table_n_max_species <- renderReactable({
      data$detections %>%
        dplyr::count(recorder_id, common) %>%
        dplyr::slice_max(n, n = 10, by = recorder_id) %>%
        tidyr::pivot_wider(names_from = recorder_id, values_from = n, values_fill = 0) %>%
        reactable::reactable(
          defaultSortOrder = "desc",
          compact = TRUE,
          borderless = TRUE,
          defaultColDef = colDef(
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
          )
        )
    })

    output$map <- renderLeaflet({
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
  })
}

## To be copied in the UI
# mod_status_overview_ui("status_overview_1")

## To be copied in the server
# mod_status_overview_server("status_overview_1")
