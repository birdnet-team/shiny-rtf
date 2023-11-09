library(shiny)

# Define a UI function for your Shiny app
Wiki <- function(id) {
  fluidPage(
    titlePanel("Hawaiianisches BirdWiki"),
    fluidRow(
      column(4, imageOutput("imageDisplay1"))
    )
  )
}

# Define a server function for your Shiny app
wiki_server <- function(input, output, session) {
  # Define the path to your image file
  image_path <- reactiveVal("C:/Users/ElementXX/Desktop/eBirdconnectionXX999/Amandava_amandava_Red_Avadavat.png")

  output$imageDisplay1 <- renderImage({
    list(src = image_path(), height = 300)
  }, deleteFile = FALSE)

  # Example of how you can change the image source based on an event
  observeEvent(input$changeImage, {
    # Change the image source to a different image
    new_image_path <- "Neuer/Pfad/Zum/Bild.png"
    image_path(new_image_path)
    onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
  })
}

# Start the Shiny App
shinyApp(ui = Wiki("my_app_id"), server = wiki_server)
