#' @importFrom shiny NS tagList
#' @import httr
#' @import png
#' @import shinyjs

# Define custom img1 function
img1 <- function(src, alt, style) {
  tags$img(src = src, alt = alt, style = style)
}

Wiki <- function(id) {
  ns <- NS(id)

    image_paths <- c(
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\BirdWatcherImagesXX\\1_Amandava_amandava_Red_Avadavat.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\BirdWatcherImagesXX\\2_Northern_Pintails_(Male_&_Female)_I_IMG_0911.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\BirdWatcherImagesXX\\3_Green-winged_Teal,_Port_Aransas,_Texas.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\BirdWatcherImagesXX\\Anas platyrhynchos_Mallard.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\BirdWatcherImagesXX\\Anous minutus_Black Noddy.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\BirdWatcherImagesXX\\Anous stolidus_Brown Noddy.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\BirdWatcherImagesXX\\Anser albifrons_Greater White-fronted Goose.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\BirdWatcherImagesXX\\Anser caerulescens_Snow Goose.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\BirdWatcherImagesXX\\Ardea herodias_Great Blue Heron.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\BirdWatcherImagesXX\\Ardenna grisea_Sooty Shearwater.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\BirdWatcherImagesXX\\Ardenna pacifica_Wedge-tailed Shearwater.png"
    )


  fluidPage(
    titlePanel("Hawaiian Birdwatching Encyclopedia -- work in progress mwrxx999"),
    fluidRow(

      lapply(seq_along(image_paths), function(i) {#oder image paths
        tagList(
          img1(src = image_paths[i], alt = paste0("image", i), style = "width:300px;height:300px;"),
          uiOutput(ns(paste0("image_output", i)))
        )
      }),

      column(2, imageOutput1(ns("imageDisplay1"))),
      column(2, imageOutput2(ns("imageDisplay2"))),
      column(2, imageOutput3(ns("imageDisplay3"), click = "image_click3")),
      column(2, imageOutput4(ns("imageDisplay4"), click = "image_click4")),
      column(2, imageOutput5(ns("imageDisplay5"), click = "image_click5")),
      column(2, imageOutput6(ns("imageDisplay6"), click = "image_click6")),
      column(2, imageOutput7(ns("imageDisplay7"), click = "image_click7")),
      column(2, imageOutput8(ns("imageDisplay8"), click = "image_click8")),
      column(2, imageOutput9(ns("imageDisplay9"), click = "image_click9")),
      column(2, imageOutput10(ns("imageDisplay10"), click = "image_click10")),
      column(2, imageOutput11(ns("imageDisplay11"), click = "image_click11"))

    ),
    useShinyjs()
  )
}

wiki_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns


    # Render images dynamically based on the number of images and their paths
    for (i in seq_along(data$image_paths)) {
      print("ready for displaying")
      download.file(image_path1, "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\BirdWatcherImagesXX\\1_Amandava_amandava_Red_Avadavat.png", mode = "wb")
      output[[ns(paste0("image_output", i))]] <- renderImage({
        img1(src = data$image_paths[i], style = "max-width:100%", alt = paste0("Bild ", i, " nicht gefunden"))
      }, deleteFile = FALSE)
    }
  })
}

