#' status_overview UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_status_overview_ui <- function(id){
  ns <- NS(id)
  tagList(
      uiOutput(ns("status_boxes"))
  )
}

#' status_overview Server Functions
#'
#' @noRd
mod_status_overview_server <- function(id, data){
  moduleServer( id, function(input, output, session){
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

    # my_valuebox <- function(status_message, recorder_id, status_icon, status, last_event, freq_jobs, free_disk, n_errors, ...) {
    #   bslib::value_box(
    #     title = status_message,
    #     value = recorder_id,
    #     showcase = bsicons::bs_icon(status_icon),
    #     theme_color = status,
    #     p("Last event: ", strftime(last_event, "%F %T", usetz = TRUE, tz = lubridate::tz(last_event))),
    #     p("Jobs per hour: ", round(freq_jobs), 1),
    #     p("Free disc: ", free_disk),
    #     p("Errors: ", n_errors)
    #   )
    # }
    my_valuebox <- function(status_message, recorder_id, status_icon, status, last_event, time_since_last_job,...) {
      bs4Dash::infoBox(
        title = status_message,
        value = recorder_id,
        subtitle = p("Last event",
                     strftime(last_event, "%F %T", usetz = TRUE, tz = lubridate::tz(last_event)),
                     br(),
                     "(",round(time_since_last_job, 0), "minutes ago", ")"),
        color = status,
        icon = icon(status_icon)
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

    output$status_boxes <- renderUI({
        purrr::pmap(log_summary(), my_valuebox)
    })

    # observe({
    #   golem::message_dev("log_summary")
    #   golem::print_dev(log_summary())
    # })

  })
}

## To be copied in the UI
# mod_status_overview_ui("status_overview_1")

## To be copied in the server
# mod_status_overview_server("status_overview_1")
