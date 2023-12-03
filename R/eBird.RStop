# Install and load required packages
if (!require("shiny")) install.packages("shiny")
if (!require("shinyjs")) install.packages("shinyjs")

library(shiny)
library(shinyjs)
library(png)

img1 <- function(src, alt, style = "") {
  tags$img(src = src, alt = alt, style = style)
}

# Function to preload images
preloadImages <- function(image_paths) {
  lapply(image_paths, function(path) {
    readBin(path, "raw", file.exists(path))
  })
}

# Shiny App Definition
Wiki <- function(id, image_paths) {
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

wiki_server <- function(id, image_paths) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Preload images
    preloadImages(image_paths)

    for (i in seq_along(image_paths)) {
      download.file(image_paths[i], paste0("www/", basename(image_paths[i])), mode = "wb")
      output[[ns(paste0("image_output", i))]] <- renderImage({
        img1(src = paste0("www/", basename(image_paths[i])), style = "max-width:100%", alt = paste0("Bild ", i, " nicht gefunden"))
      }, deleteFile = FALSE)
    }
  })
}

image_paths <- c(
  "app/www/1_Amandava_amandava_Red_Avadavat.png",
  "app/www/2_Northern_Pintails_(Male_&_Female)_I_IMG_0911.png",
  "app/www/3_Green-winged_Teal,_Port_Aransas,_Texas.png",
  "app/www/Anas platyrhynchos_Mallard.png",
  "app/www/Anous minutus_Black Noddy.png",
  "app/www/Anous stolidus_Brown Noddy.png",
  "app/www/Anser albifrons_Greater White-fronted Goose.png",
  "app/www/Anser caerulescens_Snow Goose.png",
  "app/www/Ardea herodias_Great Blue Heron.png",
  "app/www/Ardenna grisea_Sooty Shearwater.png",
  "app/www/BirdNETmonitor/BirdWatcherImages/Ardenna pacifica_Wedge-tailed Shearwater.png"
)

# Create Shiny app
# shinyApp(
#   ui = Wiki("wiki", image_paths),
#   server = function(input, output, session) {
#     wiki_server("wiki", image_paths)
#   }
# )
