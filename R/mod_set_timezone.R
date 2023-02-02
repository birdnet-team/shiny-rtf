#' set_timezone UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_set_timezone_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shinyjs::useShinyjs(),
    selectizeInput(
      ns("timezone"),
      NULL,
      choices = c(
        OlsonNames()
      )
    )
  )
}

#' set_timezone Server Functions
#'
#' @noRd
mod_set_timezone_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observe({
      cmd <- sprintf(
        'var tz = Intl.DateTimeFormat().resolvedOptions().timeZone; Shiny.setInputValue("%s", tz);',
        session$ns("timezone")
      )
      shinyjs::runjs(cmd)
      golem::message_dev("TIMEZONE")
      golem::print_dev(cmd)
      golem::print_dev(input$timezone)
    })
  })
}

## To be copied in the UI
# mod_set_timezone_ui("set_timezone_1")

## To be copied in the server
# mod_set_timezone_server("set_timezone_1")
