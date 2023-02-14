#' global_filter UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_global_filter_ui <- function(id){
  ns <- NS(id)
  tagList(
    shinyWidgets::dropMenu(
      # block = TRUE,
      # label = "Filters",
      # icon = icon("filter"),
      # shinyWidgets::actionBttn("id", label = "Filters", icon = icon("filter"), style = "bordered"),
      placement = "bottom-start",
      arrow = FALSE,
      div(
        id = ns("drop_menu"),
        class = "btn btn-default action-button",
        div(icon("filter"), div("Filters", style = "display: inline-block; margin-left: 5px"))
        ),
      shinyWidgets::pickerInput(
        ns("recorder_id"),
        label = "Recorder ID",
        multiple = TRUE,
        choices = NULL,
        options = pickerOptions(
          style = "btn-default"
        )
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
  )
}

#' global_filter Server Functions
#'
#' @noRd
mod_global_filter_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    data_filtered <- reactiveValues(
      detections = NULL,
      logs = NULL,
      recorders = NULL
    )

    observe({
     req(data$recorders)
      shinyWidgets::updatePickerInput(
        session = session,
        inputId = "recorder_id",
        choices = data$recorders$recorder_id,
        selected = data$recorders$recorder_id
      )
    })

    #filter
    observe({
      req(data$detections)
      req(data$logs)
      req(data$recorders)
      req(input$recorder_id)

      data_filtered$detections <-
        data$detections %>%
        dplyr::filter(
          recorder_id %in% input$recorder_id,
          dplyr::between(confidence, min(input$confidence), max(input$confidence))
        )
      data_filtered$logs <-
        data$logs %>%
        dplyr::filter(
          recorder_id %in% input$recorder_id,
        )
      data_filtered$recorders <- data$recorders

    })

    # # filter detections
    # observe({
    #   req(data$detections)
    #   data_filtered$detections <-
    #     data$detections %>%
    #     filter(
    #       recorder_id %in% input$recorder_id,
    #       between(confidence, min(input$confidence), max(input$confidence))
    #     )
    # })
    #
    # # filter log
    # observe({
    #   req(data$logs)
    #   data_filtered$logs <-
    #     data$logs %>%
    #     filter(
    #       recorder_id %in% input$recorder_id,
    #     )
    # })
    #
    # observe({
    #   req(data$recorders)
    #   data_filtered$recorders <- data$recorders
    # })

    return(data_filtered)
  })
}

## To be copied in the UI
# mod_global_filter_ui("global_filter_1")

## To be copied in the server
# mod_global_filter_server("global_filter_1")
