library(shiny)
library(shinyjs)

Wiki <- function(id) {
  ns <- NS(id)

  fluidPage(
    titlePanel("Hawaiian Birdwatching Encyclopedia"),
    fluidRow(
      column(2, imageOutput(ns("imageDisplay1"))),
      column(2, imageOutput(ns("imageDisplay2"))),
      column(2, imageOutput("#imageDisplay3", click = "image_click3")),
      column(2, imageOutput("#imageDisplay4", click = "image_click4")),
      column(2, imageOutput("#imageDisplay5", click = "image_click5")),
      column(2, imageOutput("#imageDisplay6", click = "image_click6")),
      column(2, imageOutput("#imageDisplay7", click = "image_click7")),
      column(2, imageOutput("#imageDisplay8", click = "image_click8")),
      column(2, imageOutput("#imageDisplay9", click = "image_click9")),
      column(2, imageOutput("#imageDisplay10", click = "image_click10")),
      column(2, imageOutput("#imageDisplay11", click = "image_click11"))
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

    output$imageDisplay1 <- renderImage({
      list(src = image_path1, height = 300)
         #shinyjs::enable("imageDisplay1")
         shinyjs::onclick(selector = "imageDisplay1", code = 'window.open("https://ebird.org/species/redava", "_blank");')
       })


    output$imageDisplay2 <- renderImage({
      list(src = image_path2, height = 300)
          #shinyjs::enable("#imageDisplay2")
         shinyjs::onclick(selector = "#imageDisplay2", code = 'window.open("https://ebird.org/species/norpin", "_blank");')
       })




    output$imageDisplay3 <- renderImage({
      list(src = image_path3, height = 300)
    })

    observeEvent(input$imageDisplay3, {
      shinyjs::enable("imageDisplay3")
      shinyjs::onclick(selector = "#imageDisplay3", code = 'window.open("https://ebird.org/species/gnwtea", "_blank");')
    })

    output$imageDisplay4 <- renderImage({
      list(src = image_path4, height = 300)
    })

    observeEvent(input$imageDisplay4, {
      shinyjs::enable("imageDisplay4")
      shinyjs::onclick(selector = "#imageDisplay4", code = 'window.open("https://ebird.org/species/mallard", "_blank");')
    })

    output$imageDisplay5 <- renderImage({
      list(src = image_path5, height = 300)
    })

    observeEvent(input$imageDisplay5, {
      shinyjs::enable("imageDisplay5")
      shinyjs::onclick(selector = "#imageDisplay5", code = 'window.open("https://ebird.org/species/blackno", "_blank");')
    })

    output$imageDisplay6 <- renderImage({
      list(src = image_path6, height = 300)
    })

    observeEvent(input$imageDisplay6, {
      shinyjs::enable("imageDisplay6")
      shinyjs::onclick(selector = "#imageDisplay6", code = 'window.open("https://ebird.org/species/brownno", "_blank");')
    })

    output$imageDisplay7 <- renderImage({
      list(src = image_path7, height = 300)
    })

    observeEvent(input$imageDisplay7, {
      shinyjs::enable("imageDisplay7")
      shinyjs::onclick(selector = "#imageDisplay7", code = 'window.open("https://ebird.org/species/whifro", "_blank");')
    })

    output$imageDisplay8 <- renderImage({
      list(src = image_path8, height = 300)
    })

    observeEvent(input$imageDisplay8, {
      shinyjs::enable("imageDisplay8")
      shinyjs::onclick(selector = "#imageDisplay8", code = 'window.open("https://ebird.org/species/snowgo", "_blank");')
    })

    output$imageDisplay9 <- renderImage({
      list(src = image_path9, height = 300)
    })

    observeEvent(input$imageDisplay9, {
      shinyjs::enable("imageDisplay9")
      shinyjs::onclick(selector = "#imageDisplay9", code = 'window.open("https://ebird.org/species/grebhe", "_blank");')
    })

    output$imageDisplay10 <- renderImage({
      list(src = image_path10, height = 300)
    })

    observeEvent(input$imageDisplay10, {
      shinyjs::enable("imageDisplay10")
      shinyjs::onclick(selector = "#imageDisplay10", code = 'window.open("https://ebird.org/species/sooshe", "_blank");')
    })

    output$imageDisplay11 <- renderImage({
      list(src = image_path11, height = 300)
    })

    observeEvent(input$imageDisplay11, {
      shinyjs::enable("imageDisplay11")
      shinyjs::onclick(selector = "#imageDisplay11", code = 'window.open("https://ebird.org/species/wetshe", "_blank");')
    })

  })
}

#shinyApp(Wiki, wiki_server)
