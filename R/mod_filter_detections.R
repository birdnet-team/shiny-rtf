#' filter_detections UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import dplyr
#' @import lubridate
#' @import shinyWidgets
mod_filter_detections_ui <- function(id) {
  ns <- NS(id)
  tagList(

    # selectizeInput(
    #   ns("fixed_time_interval")
    # )
    sliderInput(
      ns("datetime"),
      label = "Datetime",
      min = Sys.Date() - lubridate::days(1),
      max = Sys.Date(),
      value = c(Sys.Date() - lubridate::days(1), Sys.Date()),
      timeFormat = "'%Y-%m-%d'"
    ),
    selectInput(
      ns("recorder_id"),
      label = "Recorder ID",
      multiple = TRUE,
      choices = NULL
    ),
    shinyWidgets::pickerInput(
      ns("species_code"),
      label = "Species Code",
      multiple = TRUE,
      choices = c("Choose" = ""),
      options = list(
        `actions-box` = TRUE)
    ),
    sliderInput(
      ns("confidence"),
      label = "Confidence",
      min = 0,
      max = 1,
      step = 0.1,
      value = c(0.1, 1)
    )
  )
}

#' filter_detections Server Functions
#'
#' @noRd
mod_filter_detections_server <- function(id, detections) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observe({
      updateSliderInput(
        session = session,
        inputId = "datetime",
        min = min(detections()$datetime),
        max = max(detections()$datetime),
        value = c(min(detections()$datetime), max(detections()$datetime))
      )
    }) %>% bindEvent(detections())

    observe({
      req(detections())
      updateSelectInput(
        session = session,
        inputId = 'recorder_id',
        choices = c(unique(detections()$recorder_id)),
        selected = unique(detections()$recorder_id)
      )

      updatePickerInput(
        session = session,
        inputId = "species_code",
        choices = sort(unique(detections()$species_code)),
        selected = unique(detections()$species_code)
      )
    }) %>% bindEvent(input$datetime)

    detections_timerange <- reactive({
      detections() %>%
        filter(between(datetime, min(input$datetime), max(input$datetime)))
    })


    detections_filtered <- reactive({
      detections_timerange() %>%
        filter(
          recorder_id %in% input$recorder_id,
          species_code %in% input$species_code,
          between(confidence, min(input$confidence), max(input$confidence))
        )
    })

    return(detections_filtered)


  })
}

## To be copied in the UI
# mod_filter_detections_ui("filter_detections_1")

## To be copied in the server
# mod_filter_detections_server("filter_detections_1")
