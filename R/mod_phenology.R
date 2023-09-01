#' phenology UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_phenology_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(column(
      6,
      shinyWidgets::panel(
        heading = "Filter",
        selectizeInput(
          ns("species_filter"),
          label = "Species",
          choices = c("Choose" = "", sort(birdnames$common))
        )
      )
    )),
    fluidRow(column(
      6,
      echarts4rOutput(ns(
        "phenology"
      ))
    ))
  )
}

#' phenology Server Functions
#'
#' @noRd
mod_phenology_server <- function(id, data, url) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observe({
      golem::message_dev("FILTERED DATA IN PHENOLOGY")
      golem::print_dev(glimpse(data$detections))
      golem::print_dev(glimpse(data$recorders))
    })

    data_phenology <- reactiveValues(
      detections = NULL,
      calendar_dats = NULL,
      suntimes = NULL
    )

    # download
    detections <- reactive({
      req(input$species_filter)
      selected_species_code <-
        birdnames$code[birdnames$common == input$species_filter]
      golem::print_dev(selected_species_code)
      golem::print_dev(data$recorders$recorder_id)

      params <-
        list("species_code" = selected_species_code, "confidence__gte" = 0.1)
      dets <- lapply(data$recorders$recorder_id, function(x) {
        get_detections(url, params = c(params, "recorder_id" = x))
      }) |> do.call(what = rbind, args = _)
      return(dets)
    }) |>
      bindCache(input$species_filter) |>
      bindEvent(input$species_filter)

    observe({
      golem::message_dev("DOWNLOADED DATA IN PHENOLOGY")
      golem::print_dev(glimpse(detections()))
    })

  })
}

## To be copied in the UI
# mod_phenology_ui("phenology_1")

## To be copied in the server
# mod_phenology_server("phenology_1")
