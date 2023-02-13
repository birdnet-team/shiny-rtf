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
    shinyWidgets::pickerInput(
      ns("timezone"),
      NULL,
      choices = c(
        OlsonNames()
      ),
      options = pickerOptions(
        liveSearch = TRUE,
        liveSearchPlaceholder = "search timezones",
        style = "btn-default"
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

    # reactiveValue that hold the timezone
    # starts with NULL
    tz <- reactiveVal()

    # get timezone from browser and set input from JS
    observe({
      cmd <- sprintf(
        'var tz_browser = Intl.DateTimeFormat().resolvedOptions().timeZone; Shiny.setInputValue("%s", tz_browser);',
        session$ns("tz_browser")
      )
      shinyjs::runjs(cmd)
    })

    # when Browser TZ is available, update selectInput
    observe({
      updateSelectizeInput(
        session,
        "timezone",
        selected = input$tz_browser
      )
    })

    # when browser TZ is available, update reactiveValue
    observe({
      req(input$tz_browser)
      tz(input$timezone)
    }) %>% bindEvent(input$timezone)

    return(tz)

  })
}

## To be copied in the UI
# mod_set_timezone_ui("set_timezone_1")

## To be copied in the server
# mod_set_timezone_server("set_timezone_1")
