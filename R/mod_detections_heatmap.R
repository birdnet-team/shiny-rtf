#' detections_heatmap UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_detections_heatmap_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' detections_heatmap Server Functions
#'
#' @noRd 
mod_detections_heatmap_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_detections_heatmap_ui("detections_heatmap_1")
    
## To be copied in the server
# mod_detections_heatmap_server("detections_heatmap_1")
