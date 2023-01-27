#' sign_out UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import polished
mod_sign_out_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$li(
      class = "dropdown",
      actionButton(
        ns("sign_out"),
        "Sign Out",
        icon = icon("sign-out-alt")
      )
    )
  )
}

#' sign_out Server Functions
#'
#' @noRd
mod_sign_out_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    observeEvent(input$sign_out, {
      polished::sign_out_from_shiny()
      session$reload()
    })
  })
}

## To be copied in the UI
# mod_sign_out_ui("sign_out_1")

## To be copied in the server
# mod_sign_out_server("sign_out_1")
