#' @importFrom shiny NS tagList
#' @import httr
#' @import png
#' @import shinyjs
#library(shinyjs)

# Define custom img1 function
img1 <- function(src, alt, style) {
  tags$img(src = src, alt = alt, style = style)
}

Wiki <- function(id) {
  ns <- NS(id)

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

  fluidPage(
    titlePanel("Hawaiian Birdwatching Encyclopedia -- work in progress mwrxx999"),
    fluidRow(
      lapply(seq_along(image_paths), function(i) {
        tagList(
          img1(src = image_paths[i], alt = paste0("image", i), style = "width:300px;height:300px;"),
          uiOutput(ns(paste0("image_output", i)))
        )
      })
    ),
    useShinyjs()
  )
}

wiki_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    for (i in seq_along(data$image_paths)) {
      print("ready for displaying")

      # Set the local path for saving the image
      local_path <- paste0("C:/path/to/save/image", i, ".png")

      # Download the image
      download.file(data$image_paths[i], local_path, mode = "wb", quiet = TRUE)

      # Check if the download was successful
      if (file.exists(local_path)) {
        output[[ns(paste0("image_output", i))]] <- renderImage({
          img1(src = local_path, style = "max-width:100%", alt = paste0("Bild ", i, " nicht gefunden"))
        }, deleteFile = FALSE)
      } else {
        print(paste("Error downloading image", i))
      }
    }
  })
}

# Example usage
# image_paths <- c(
#   "BirdNETmonitor/BirdWatcherImagesXX/1_Amandava_amandava_Red_Avadavat.png",
#   "BirdNETmonitor/BirdWatcherImagesXX/2_Northern_Pintails_(Male_&_Female)_I_IMG_0911.png",
#   "BirdNETmonitor/BirdWatcherImages/3_Green-winged_Teal,_Port_Aransas,_Texas.png",
#   "BirdNETmonitor/BirdWatcherImages/Anas platyrhynchos_Mallard.png",
#   "BirdNETmonitor/BirdWatcherImages/Anous minutus_Black Noddy.png",
#   "BirdNETmonitor/BirdWatcherImages/Anous stolidus_Brown Noddy.png",
#   "BirdNETmonitor/BirdWatcherImages/Anser albifrons_Greater White-fronted Goose.png",
#   "BirdNETmonitor/BirdWatcherImages/Anser caerulescens_Snow Goose.png",
#   "BirdNETmonitor/BirdWatcherImages/Ardea herodias_Great Blue Heron.png",
#   "BirdNETmonitor/BirdWatcherImages/Ardenna grisea_Sooty Shearwater.png",
#   "BirdNETmonitor/BirdWatcherImages/Ardenna pacifica_Wedge-tailed Shearwater.png"
# )
