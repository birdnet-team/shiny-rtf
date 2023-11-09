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
    shinyjs::runjs("window.open('https://de.wikipedia.org/wiki/Vogel', '_blank');")
  })

  # Verwenden Sie Schrägstriche in Pfadangaben und korrigieren Sie die paste0-Funktion
  image_path1 <- reactiveVal("www/Amandava_amandava_Red_Avadavat.png")

  output$imageDisplay1 <- renderImage({
    list(src = image_path1(), height = 300)
  }, deleteFile = FALSE)
}

# Starten Sie die Shiny-App
shinyApp(ui = Wiki(), server = wiki_server)
