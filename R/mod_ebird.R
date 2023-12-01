#' ebird UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_ebird_ui <- function(id){
  ns <- NS(id)
  tagList(
    titlePanel("Hawaiian Birdwatching Encyclopedia -- work in progress mwrxx999"),
    fluidRow(
      uiOutput(ns("images"))
    )
  )
}

#' ebird Server Functions
#'
#' @noRd
mod_ebird_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    image_paths <- c(
      "www/1_Amandava_amandava_Red_Avadavat.png",
      "www/2_Northern_Pintails_(Male_&_Female)_I_IMG_0911.png",
      "www/3_Green-winged_Teal,_Port_Aransas,_Texas.png",
      "www/Anas platyrhynchos_Mallard.png",
      "www/Anous minutus_Black Noddy.png",
      "www/Anous stolidus_Brown Noddy.png",
      "www/Anser albifrons_Greater White-fronted Goose.png",
      "www/Anser caerulescens_Snow Goose.png",
      "www/Ardea herodias_Great Blue Heron.png",
      "www/Ardenna grisea_Sooty Shearwater.png",
      "www/BirdNETmonitor/BirdWatcherImages/Ardenna pacifica_Wedge-tailed Shearwater.png"
    )

    output$images <- renderUI({
      lapply(image_paths, function(x) {
        div(
          style = "margin-bottom: 10px; margin-top: 10px; margin-left: 10px; margin-right: 10px; display: inline-block",
          shiny::img(src = x, height = "200px")
        )
      })
    })
  })
}

## To be copied in the UI
# mod_ebird_ui("ebird_1")

## To be copied in the server
# mod_ebird_server("ebird_1")
