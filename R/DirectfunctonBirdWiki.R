library(shiny)

# Define a UI function for your Shiny app
Wiki <- function(id) {
  fluidPage(
    titlePanel("Hawaiianisches BirdWiki"),
    fluidRow(
      column(4, uiOutput("imageDisplay1"))
    )
  )
}

# Define a server function for your Shiny app
wiki_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    # Define the path to your image file
    image_path <- "C:/Users/ElementXX/Desktop/eBirdconnectionXX999/Amandava_amandava_Red_Avadavat.png"

    # Create a reactiveVal to store the image source
    image_source <- reactiveVal(image_path)

    # Render the image
    output$imageDisplay1 <- renderUI({
      tags$img(
        src = image_source(),
        height = "300px",
        onclick = "window.open('https://ebird.org/species/hawgoo', '_blank')"
      )
    })

    # Example of how you can change the image source based on an event
    observeEvent(input$changeImage, {
      # Change the image source to a different image
      new_image_path <- "C:/Users/ElementXX/Desktop/eBirdconnectionXX999/Amandava_amandava_Red_Avadavat.png"
      image_source(new_image_path)
    })
  })
}

shinyApp(Wiki("my_app_id"), wiki_server)
