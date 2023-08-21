library(shiny)

ui <- fluidPage(
  titlePanel("Anzeige von Bildern aus vordefinierter URL"),

  mainPanel(
    actionButton("displayBtn", "Bild anzeigen"),
    htmlOutput("imageOutput")
  )
)

server <- function(input, output) {
  img_url <- "http://viewer:birdnet2023!@166.143.21.131:8001/cgi-bin/image.jpg?imgprof=BirdNET"

  output$imageOutput <- renderUI({
    if (input$displayBtn > 0) {
      img_tag <- tags$img(src = img_url,
                          alt = "Bild nicht gefunden",
                          style = "max-width:100%")

      img_tag
    }
  })
}

shinyApp(ui = ui, server = server)
