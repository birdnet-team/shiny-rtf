library(shiny)

# Verzeichnis, in dem sich die Bilder befinden
imagePath <- "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/wiki_img"

# Funktion zum Laden aller Bilder im Verzeichnis
loadImages <- function(directory) {
  images <- list.files(directory, full.names = TRUE)
  images <- lapply(images, function(path) {
    list(file_path = path, file_url = tools::file_path_as_absolute(path))
  })
  images
}

ui <- fluidPage(
  titlePanel("Bird Image Viewer"),
  mainPanel(
    uiOutput("birdImages")
  )
)

server <- function(input, output) {
  images <- loadImages(imagePath)

  output$birdImages <- renderUI({
    bird_images <- lapply(images, function(image) {
      tags$img(src = image$file_url, width = "300px", height = "300px")
    })
    tagList(bird_images)  # Direkt tagList verwenden, um die Bilder anzuzeigen
  })
}

shinyApp(ui, server)
