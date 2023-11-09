library(shiny)
library(shinyjs)

Wiki <- function(id) {
  fluidPage(
    titlePanel("Hawaiian Birdwatching Wikipedia"),
    fluidRow(
      column(2, imageOutput("imageDisplay1", click = "image_click1")),
      column(2, imageOutput("imageDisplay2", click = "image_click2")),
      column(2, imageOutput("imageDisplay3", click = "image_click3")),
    ),
    useShinyjs()
  )
}

wiki_server <- function(input, output, session) {

  observeEvent(input$image_click1, {
    shinyjs::runjs("window.open('https://de.wikipedia.org/wiki/Vogel', '_blank');")})
  image_path1 <- reactiveVal("C:/Users/ElementXX/Desktop/eBirdconnectionXX999/Amandava_amandava_Red_Avadavat.png")

  output$imageDisplay1 <- renderImage({
    list(src = image_path1(), height = 300)
  }, deleteFile = FALSE)

  observeEvent(input$image_click2, {
    shinyjs::runjs("window.open('https://de.wikipedia.org/wiki/Vogel', '_blank');")})
  image_path2 <- reactiveVal("C:/Users/ElementXX/Desktop/eBirdconnectionXX999/11_Wedge_tailed_shearwater2.png")

  output$imageDisplay2 <- renderImage({
    list(src = image_path2(), height = 300)
  }, deleteFile = FALSE)

  observeEvent(input$image_click3, {
    shinyjs::runjs("window.open('https://de.wikipedia.org/wiki/Vogel', '_blank');")})
  image_path3 <- reactiveVal("C:/Users/ElementXX/Desktop/eBirdconnectionXX999/Amandava_amandava_Red_Avadavat.png")

  output$imageDisplay3 <- renderImage({
    list(src = image_path3(), height = 300)
  }, deleteFile = FALSE)




}

#shinyApp(Wiki, wiki_server)
