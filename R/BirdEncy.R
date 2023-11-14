library(shiny)
library(shinyjs)

Wiki <- function(id) {
  ns <- NS(id)

  fluidPage(
    titlePanel("Hawaiian Birdwatching Encyclopedia"),
    fluidRow(
      column(2, imageOutput1(ns("imageDisplay1"))),
      column(2, imageOutput2(ns("imageDisplay2"))),
      column(2, imageOutput3(ns("imageDisplay3"))),
      column(2, imageOutput4(ns("imageDisplay4"))),
      column(2, imageOutput5(ns("imageDisplay5"))),
      column(2, imageOutput6(ns("imageDisplay6"))),
      column(2, imageOutput7(ns("imageDisplay7"))),
      column(2, imageOutput8(ns("imageDisplay8"))),
      column(2, imageOutput9(ns("imageDisplay9"))),
      column(2, imageOutput10(ns("imageDisplay10"))),
      column(2, imageOutput11(ns("imageDisplay11")))
    ),
    useShinyjs()
  )
}

wiki_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    image_path1 <- reactiveVal("BirdNETmonitor/BirdWatcherImagesXX/1_Amandava_amandava_Red_Avadavat.png")
    image_path2 <- reactiveVal("BirdNETmonitor/BirdWatcherImagesXX/2_Northern_Pintails_(Male_&_Female)_I_IMG_0911.png")
    image_path3 <- reactiveVal("BirdNETmonitor/BirdWatcherImages/3_Green-winged_Teal,_Port_Aransas,_Texas.png")
    image_path4 <- reactiveVal("BirdNETmonitor/BirdWatcherImages/Anas platyrhynchos_Mallard.png")
    image_path5 <- reactiveVal("BirdNETmonitor/BirdWatcherImages/Anous minutus_Black Noddy.png")
    image_path6 <- reactiveVal("BirdNETmonitor/BirdWatcherImages/Anous stolidus_Brown Noddy.png")
    image_path7 <- reactiveVal("BirdNETmonitor/BirdWatcherImages/Anser albifrons_Greater White-fronted Goose.png")
    image_path8 <- reactiveVal("BirdNETmonitor/BirdWatcherImages/Anser caerulescens_Snow Goose.png")
    image_path9 <- reactiveVal("BirdNETmonitor/BirdWatcherImages/Ardea herodias_Great Blue Heron.png")
    image_path10 <- reactiveVal("BirdNETmonitor/BirdWatcherImages/Ardenna grisea_Sooty Shearwater.png")
    image_path11 <- reactiveVal("BirdNETmonitor/BirdWatcherImages/Ardenna pacifica_Wedge-tailed Shearwater.png")



    observeEvent(input$imageDisplay1, {
        output$imageOutput1 <- renderImage({
          list(src = img_path1,
               style = "max-width:100%",
               alt = "image not found")
        }, ignoreInit = TRUE)
    })


  })
}
