library(shiny)
library(shinyjs)

Wiki <- function(id) {
  ns <- NS(id)

  fluidPage(
    titlePanel("Hawaiian Birdwatching Encyclopedia -- work in progress mwrxx999"),
    fluidRow(
      column(2,(ns("displayBtnUnit1"))),
      column(2,(ns("displayBtnUnit2"))),
      column(2,(ns("displayBtnUnit3"))),
      column(2,(ns("displayBtnUnit4"))),
      column(2,(ns("displayBtnUnit5"))),
      column(2,(ns("displayBtnUnit6"))),
      column(2,(ns("displayBtnUnit7"))),
      column(2,(ns("displayBtnUnit8"))),
      column(2,(ns("displayBtnUnit9"))),
      column(2,(ns("displayBtnUnit10"))),
      column(2,(ns("displayBtnUnit11"))),

    ),
    fluidPage(
      column(11, uiOutput(ns("imageOutput1")))
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



    observeEvent(input$displayBtnUnit1, {
      output$imageOutput1 <- renderUI({
        output$imageOutput1 <- renderImage({
          list(src = img_path1,
               style = "max-width:100%",
               alt = "Bild 1 nicht gefunden")
        }, deleteFile = FALSE)
      })
    })


  })
}
