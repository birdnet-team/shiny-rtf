#' health UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_health_ui <- function(id){
  ns <- NS(id)
  tagList(
    reactableOutput(ns('overview_table'))

  )
}

#' health Server Functions
#'
#' @noRd
mod_health_server <- function(id, data){
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
# mod_health_ui("health_1")

## To be copied in the server
# mod_health_server("health_1")
