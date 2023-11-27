# Install and load required packages
if (!require("shiny")) install.packages("shiny")
if (!require("shinyjs")) install.packages("shinyjs")

library(shiny)
library(shinyjs)

# Funktion zum Laden von Bildern
img1 <- function(src, alt, style) {
  tags$img(src = src, alt = alt, style = style)
}

# Shiny App Definition
Wiki <- function(id) {
  ns <- NS(id)

  image_paths <- c(
    "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImagesXX/1_Amandava_amandava_Red_Avadavat.png",
    "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImagesXX/2_Northern_Pintails_(Male_&_Female)_I_IMG_0911.png",
    # ... (Weiterhin alle Bildpfade hinzufügen)
  )

  fluidPage(
    titlePanel("Hawaiian Birdwatching Encyclopedia -- work in progress mwrxx999"),
    useShinyjs(),
    fluidRow(
      lapply(seq_along(image_paths), function(i) {
        tagList(
          img1(src = image_paths[i], alt = paste0("image", i), style = "width:300px;height:300px;"),
          uiOutput(ns(paste0("image_output", i)))
        )
      })
    )
  )
}

# Server-Funktion für die Shiny App
wiki_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    for (i in seq_along(data$image_paths)) {
      download.file(data$image_paths[i], paste0("www/", basename(data$image_paths[i])), mode = "wb")
      output[[ns(paste0("image_output", i))]] <- renderImage({
        img1(src = paste0("www/", basename(data$image_paths[i])), style = "max-width:100%", alt = paste0("Bild ", i, " nicht gefunden"))
      }, deleteFile = FALSE)
    }
  })
}
