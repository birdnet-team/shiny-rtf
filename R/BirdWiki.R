library(shiny)

imagePath <- "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/wiki_img"

loadImages <- function(directory) {
  images <- list.files(directory, full.names = TRUE)
  images <- lapply(images, function(path) {
    list(file_path = path, file_url = tools::file_path_as_absolute(path))
  })
  images
}

ui <- fluidPage(
  titlePanel("Hawaiian Bird Directory"),
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
    tagList(bird_images)
    # just do your own *** :D :D :D
  })
}

shinyApp(ui, server)
