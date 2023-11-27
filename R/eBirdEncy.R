# mwr xx999
img1 <- function(src, alt, style) {
  tags$img(src = src, alt = alt, style = style)
}

#' @importFrom shiny tags
#' @import httr
#' @import png
#' @import shinyjs

install.packages("shinyjs")
library(shinyjs)



Wiki <- function(id) {
  ns <- NS(id)

  image_paths <- c(
    "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImagesXX/1_Amandava_amandava_Red_Avadavat.png",
    "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImagesXX/2_Northern_Pintails_(Male_&_Female)_I_IMG_0911.png",
    "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImagesXX/3_Green-winged_Teal,_Port_Aransas,_Texas.png",
    "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImagesXX/Anas platyrhynchos_Mallard.png",
    "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImagesXX/Anous minutus_Black Noddy.png",
    "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImagesXX/Anous stolidus_Brown Noddy.png",
    "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImagesXX/Anser albifrons_Greater White-fronted Goose.png",
    "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImagesXX/Anser caerulescens_Snow Goose.png",
    "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImagesXX/Ardea herodias_Great Blue Heron.png",
    "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImagesXX/Ardenna grisea_Sooty Shearwater.png",
    "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/BirdWatcherImagesXX/Ardenna pacifica_Wedge-tailed Shearwater.png"
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
