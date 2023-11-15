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
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\BirdWatcherImagesXX\\1_Amandava_amandava_Red_Avadavat.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\BirdWatcherImagesXX\\2_Northern_Pintails_(Male_&_Female)_I_IMG_0911.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\BirdWatcherImagesXX\\3_Green-winged_Teal,_Port_Aransas,_Texas.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor/BirdWatcherImages/Anas platyrhynchos_Mallard.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor/BirdWatcherImages/Anous minutus_Black Noddy.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor/BirdWatcherImages/Anous stolidus_Brown Noddy.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor/BirdWatcherImages/Anser albifrons_Greater White-fronted Goose.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor/BirdWatcherImages/Anser caerulescens_Snow Goose.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor/BirdWatcherImages/Ardea herodias_Great Blue Heron.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor/BirdWatcherImages/Ardenna grisea_Sooty Shearwater.png",
      "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor/BirdWatcherImages/Ardenna pacifica_Wedge-tailed Shearwater.png"
    )


  fluidPage(
    titlePanel("Hawaiian Birdwatching Encyclopedia -- work in progress mwrxx999"),
    fluidRow(
<<<<<<< HEAD
      lapply(seq_along(image_paths), function(i) {#oder image paths
        tagList(
          img1(src = image_paths[i], alt = paste0("image", i), style = "width:300px;height:300px;"),
          uiOutput(ns(paste0("image_output", i)))
        )
      })
=======
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
>>>>>>> f71275d457252a6ac83332613b6e76fb65000316
    ),
    useShinyjs()
  )
}

wiki_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

<<<<<<< HEAD
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

# Example usage
image_paths <- c(
  "BirdNETmonitor/BirdWatcherImagesXX/1_Amandava_amandava_Red_Avadavat.png",
  "BirdNETmonitor/BirdWatcherImagesXX/2_Northern_Pintails_(Male_&_Female)_I_IMG_0911.png",
  "BirdNETmonitor/BirdWatcherImages/3_Green-winged_Teal,_Port_Aransas,_Texas.png",
  "BirdNETmonitor/BirdWatcherImages/Anas platyrhynchos_Mallard.png",
  "BirdNETmonitor/BirdWatcherImages/Anous minutus_Black Noddy.png",
  "BirdNETmonitor/BirdWatcherImages/Anous stolidus_Brown Noddy.png",
  "BirdNETmonitor/BirdWatcherImages/Anser albifrons_Greater White-fronted Goose.png",
  "BirdNETmonitor/BirdWatcherImages/Anser caerulescens_Snow Goose.png",
  "BirdNETmonitor/BirdWatcherImages/Ardea herodias_Great Blue Heron.png",
  "BirdNETmonitor/BirdWatcherImages/Ardenna grisea_Sooty Shearwater.png",
  "BirdNETmonitor/BirdWatcherImages/Ardenna pacifica_Wedge-tailed Shearwater.png"
)


=======
    #image_path1 <- reactiveVal("BirdNETmonitor/BirdWatcherImagesXX/1_Amandava_amandava_Red_Avadavat.png")
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
      download.file(urlUnit2, "BirdNETmonitor/BirdWatcherImagesXX/1_Amandava_amandava_Red_Avadavat.png", mode = "wb")
      output$imageOutput1 <- renderUI({
        output$imageOutput1 <- renderImage({
          list(src = img_path1,
               style = "max-width:100%",
               alt = "image not found")
        }, deleteFile = FALSE)
      })
    })

    # output$imageDisplay2 <- renderImage({
    #   list(src = image_path2(), height = 300)
    # })
    #
    # observeEvent(input$imageDisplay2, {
    #   shinyjs::enable(ns("imageDisplay2"))
    #   shinyjs::onclick(selector = paste0("#", ns("imageDisplay2")), code = 'window.open("https://ebird.org/species/norpin", "_blank");')
    # })
    #
    # #####
    #
    #
    #
    # output$imageDisplay3 <- renderImage({
    #   list(src = image_path3, height = 300)
    # })
    #
    # observeEvent(input$imageDisplay3, {
    #   shinyjs::enable("imageDisplay3")
    #   shinyjs::onclick(selector = "#imageDisplay3", code = 'window.open("https://ebird.org/species/gnwtea", "_blank");')
    # })
    #
    # output$imageDisplay4 <- renderImage({
    #   list(src = image_path4, height = 300)
    # })
    #
    # observeEvent(input$imageDisplay4, {
    #   shinyjs::enable("imageDisplay4")
    #   shinyjs::onclick(selector = "#imageDisplay4", code = 'window.open("https://ebird.org/species/mallard", "_blank");')
    # })
    #
    # output$imageDisplay5 <- renderImage({
    #   list(src = image_path5, height = 300)
    # })
    #
    # observeEvent(input$imageDisplay5, {
    #   shinyjs::enable("imageDisplay5")
    #   shinyjs::onclick(selector = "#imageDisplay5", code = 'window.open("https://ebird.org/species/blackno", "_blank");')
    # })
    #
    # output$imageDisplay6 <- renderImage({
    #   list(src = image_path6, height = 300)
    # })
    #
    # observeEvent(input$imageDisplay6, {
    #   shinyjs::enable("imageDisplay6")
    #   shinyjs::onclick(selector = "#imageDisplay6", code = 'window.open("https://ebird.org/species/brownno", "_blank");')
    # })
    #
    # output$imageDisplay7 <- renderImage({
    #   list(src = image_path7, height = 300)
    # })
    #
    # observeEvent(input$imageDisplay7, {
    #   shinyjs::enable("imageDisplay7")
    #   shinyjs::onclick(selector = "#imageDisplay7", code = 'window.open("https://ebird.org/species/whifro", "_blank");')
    # })
    #
    # output$imageDisplay8 <- renderImage({
    #   list(src = image_path8, height = 300)
    # })
    #
    # observeEvent(input$imageDisplay8, {
    #   shinyjs::enable("imageDisplay8")
    #   shinyjs::onclick(selector = "#imageDisplay8", code = 'window.open("https://ebird.org/species/snowgo", "_blank");')
    # })
    #
    # output$imageDisplay9 <- renderImage({
    #   list(src = image_path9, height = 300)
    # })
    #
    # observeEvent(input$imageDisplay9, {
    #   shinyjs::enable("imageDisplay9")
    #   shinyjs::onclick(selector = "#imageDisplay9", code = 'window.open("https://ebird.org/species/grebhe", "_blank");')
    # })
    #
    # output$imageDisplay10 <- renderImage({
    #   list(src = image_path10, height = 300)
    # })
    #
    # observeEvent(input$imageDisplay10, {
    #   shinyjs::enable("imageDisplay10")
    #   shinyjs::onclick(selector = "#imageDisplay10", code = 'window.open("https://ebird.org/species/sooshe", "_blank");')
    # })
    #
    # output$imageDisplay11 <- renderImage({
    #   list(src = image_path11, height = 300)
    # })
    #
    # observeEvent(input$imageDisplay11, {
    #   shinyjs::enable("imageDisplay11")
    #   shinyjs::onclick(selector = "#imageDisplay11", code = 'window.open("https://ebird.org/species/wetshe", "_blank");')
    # })

  })
}

#shinyApp(Wiki, wiki_server)
>>>>>>> f71275d457252a6ac83332613b6e76fb65000316
