# Install and load required packages
if (!require("shiny")) install.packages("shiny")
if (!require("shinyjs")) install.packages("shinyjs")

library(shiny)
library(shinyjs)

img1 <- function(src, alt, style = "") {
  tags$img(src = src, alt = alt, style = style)
}

# Shiny App Definition
Wiki <- function(id, image_paths = character(0)) {
  ns <- NS(id)

  fluidPage(
    titlePanel("Hawaiian Birdwatching Encyclopedia -- work in progress mwrxx999"),
    useShinyjs(),
    fluidRow(
      lapply(seq_along(image_paths), function(i) {
        image_path <- image_paths[i]
        tagList(
          img1(src = image_path, alt = paste0("image", i), style = "width:300px;height:300px;"),
          uiOutput(ns(paste0("image_output", i)))
        )
      })
    )
  )
}

# Server-Funktion für die Shiny App
wiki_server <- function(id, image_paths = character(0)) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    for (i in seq_along(image_paths)) {
      download.file(image_paths[i], paste0("www/", basename(image_paths[i])), mode = "wb")
      output[[ns(paste0("image_output", i))]] <- renderImage({
        img1(src = paste0("www/", basename(image_paths[i])), style = "max-width:100%", alt = paste0("Bild ", i, " nicht gefunden"))
      }, deleteFile = FALSE)
    }
  })
}

# Example usage
image_paths <- c(
  "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImagesXX/1_Amandava_amandava_Red_Avadavat.png",
  "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImagesXX/2_Northern_Pintails_(Male_&_Female)_I_IMG_0911.png",
  "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImagesXX/3_Green-winged_Teal,_Port_Aransas,_Texas.png",
  "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImages/Anas platyrhynchos_Mallard.png",
  "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImages/Anous minutus_Black Noddy.png",
  "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImages/Anous stolidus_Brown Noddy.png",
  "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImages/Anser albifrons_Greater White-fronted Goose.png",
  "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImages/Anser caerulescens_Snow Goose.png",
  "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImages/Ardea herodias_Great Blue Heron.png",
  "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImages/Ardenna grisea_Sooty Shearwater.png",
  "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImages/Ardenna pacifica_Wedge-tailed Shearwater.png"
)
