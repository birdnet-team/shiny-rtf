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
    reactableOutput(ns('overview_table'))
  )
}

#' status_overview Server Functions
#'
#' @noRd
mod_status_overview_server <- function(id, data){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    table_dats <- reactive({
      req(data$logs)
      data$logs %>%
        select(-id) %>%
        mutate(
          datetime_pi = strftime(datetime_pi, "%F %T", tz = lubridate::tz(datetime_pi))
        )
    })

    output$overview_table <- renderReactable({
      req(data$logs)
      golem::message_dev("datetime in overview")
      golem::print_dev(data$logs$datetime_pi[1])
      golem::print_dev(class(data$logs$datetime_pi[1]))

      # data$logs %>%
      #   select(-id) %>%
      reactable(
        table_dats(),
        groupBy = "recorder_id",
        defaultSorted = list(datetime_pi = "desc"),
        columns = list(
          job_id = colDef(show = FALSE),
          datetime_pi = colDef(name = "Datetime", aggregate = 'max')
        )
      )
    })

  })
}

## To be copied in the UI
# mod_status_overview_ui("status_overview_1")

## To be copied in the server
# mod_status_overview_server("status_overview_1")
