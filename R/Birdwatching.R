library(shiny)
library(shinyjs)

Wiki <- function(id) {
  fluidPage(
    titlePanel("Hawaiian Birdwatching Wikipedia"),
    fluidRow(
      column(2, imageOutput("imageDisplay1", click = "image_click1"))
    ),
    useShinyjs()
  )
}

wiki_server <- function(input, output, session) {

  observeEvent(input$image_click1, {
    shinyjs::runjs("window.open('https://de.wikipedia.org/wiki/Vogel', '_blank');") })
  image_path1 <- reactiveVal("Amandava_amandava_Red_Avadavat.png")
  output$imageDisplay1 <- renderImage({
    list(src = paste0("app/www/", image_path1()), height = 300)
  }, deleteFile = FALSE)
}

# Start the Shiny app
shinyApp(ui = Wiki(), server = wiki_server)
