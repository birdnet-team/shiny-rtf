library(shiny)
library(shinyjs)

Wiki <- function(id) {
  ns <- NS(id)

  fluidPage(
    titlePanel("Hawaiian Birdwatching Encyclopedia"),
    fluidRow(
      column(2, imageOutput(ns("imageDisplay1"))),
      column(2, imageOutput(ns("imageDisplay2"))),
      column(2, imageOutput(ns("imageDisplay3"))),
      column(2, imageOutput(ns("imageDisplay4"))),
      column(2, imageOutput(ns("imageDisplay5"))),
      column(2, imageOutput(ns("imageDisplay6"))),
      column(2, imageOutput(ns("imageDisplay7"))),
      column(2, imageOutput(ns("imageDisplay8"))),
      column(2, imageOutput(ns("imageDisplay9"))),
      column(2, imageOutput(ns("imageDisplay10"))),
      column(2, imageOutput(ns("imageDisplay11")))
    ),
    useShinyjs()
  )
}

wiki_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    image_path1 <- reactiveVal("BirdNETmonitor/BirdWatcherImagesXX/1_Amandava_amandava_Red_Avadavat.png")
    image_path2 <- reactiveVal("BirdNETmonitor/BirdWatcherImagesXX/2_Northern_Pintails_(Male_&_Female)_I_IMG_0911.png")
    image_path3 <- reactiveVal("BirdNETmonitor/BirdWatcherImagesXX/3_Green-winged_Teal,_Port_Aransas,_Texas.png")
    image_path4 <- reactiveVal("BirdNETmonitor/BirdWatcherImagesXX/Anas platyrhynchos_Mallard.png")
    image_path5 <- reactiveVal("BirdNETmonitor/BirdWatcherImagesXX/Anous minutus_Black Noddy.png")
    image_path6 <- reactiveVal("BirdNETmonitor/BirdWatcherImagesXX/Anous stolidus_Brown Noddy.png")
    image_path7 <- reactiveVal("BirdNETmonitor/BirdWatcherImagesXX/Anser albifrons_Greater White-fronted Goose.png")
    image_path8 <- reactiveVal("BirdNETmonitor/BirdWatcherImagesXX/Anser caerulescens_Snow Goose.png")
    image_path9 <- reactiveVal("BirdNETmonitor/BirdWatcherImagesXX/Ardea herodias_Great Blue Heron.png")
    image_path10 <- reactiveVal("BirdNETmonitor/BirdWatcherImagesXX/Ardenna grisea_Sooty Shearwater.png")
    image_path11 <- reactiveVal("BirdNETmonitor/BirdWatcherImagesXX/Ardenna pacifica_Wedge-tailed Shearwater.png")



    observeEvent(input$imageDisplay1, {
      list(src = image_path2(), height = 300)
      shinyjs::enable("imageDisplay1")
      shinyjs::onclick(
        selector = paste0("#", ns("imageDisplay1")),
        code = sprintf('window.open("https://ebird.org/species/redava", "_blank");')
      )
    }, delete_file = FALSE)



    ##2

    observeEvent(input$imageDisplay2, {
      shinyjs::enable(ns("imageDisplay2"))
      shinyjs::onclick(selector = paste0("#", ns("imageDisplay2")), code = 'window.open("https://ebird.org/species/norpin", "_blank");')
    })

#####



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


shinyApp(Wiki, wiki_server)
