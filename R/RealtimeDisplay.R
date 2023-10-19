library(shiny)
library(png)
library(httr)

ui <- fluidPage(
  titlePanel("Real-Time Display of Observation Images from Units"),
  actionButton("displayBtnUnit1", "show Picture Unit 1"),
  actionButton("displayBtnUnit2", "show Picture Unit 2"),
  actionButton("displayBtnUnit3", "show Picture Unit 3"),
  uiOutput("imageOutputUnit1"),
  uiOutput("imageOutputUnit2"),
  uiOutput("imageOutputUnit3")
)

server <- function(input, output, session) {
  img_path1 <- "img1.png"
  img_path2 <- "img2.png"
  img_path3 <- "img3.png"

  urlUnit1 <- "http://viewer:birdnet2023!@166.148.48.130:8001/cgi-bin/image.jpg?imgprof=BirdNET"
  urlUnit2 <- "http://viewer:birdnet2023!@166.143.21.131:8001/cgi-bin/image.jpg?imgprof=BirdNET"
  urlUnit3 <- "http://viewer:birdnet2023!@166.148.204.108:8001/cgi-bin/image.jpg?imgprof=BirdNET"

  observeEvent(input$displayBtnUnit1, {
    download.file(urlUnit1, img_path1, mode = "wb")
    output$imageOutputUnit1 <- renderUI({
      fluidRow(
        column(7, imageOutput("imgOutput1"))
      )
    })
  })

  observeEvent(input$displayBtnUnit2, {
    download.file(urlUnit2, img_path2, mode = "wb")
    output$imageOutputUnit2 <- renderUI({
      fluidRow(
        column(7, imageOutput("imgOutput2"))
      )
    })
  })

  observeEvent(input$displayBtnUnit3, {
    download.file(urlUnit3, img_path3, mode = "wb")
    output$imageOutputUnit3 <- renderUI({
      fluidRow(
        column(7, imageOutput("imgOutput3"))
      )
    })
  })

  # Move these outside of observeEvent
  output$imgOutput1 <- renderImage({
    list(src = img_path1, style = "max-width:90%", alt = "Unit 1 nicht gefunden")
  }, deleteFile = FALSE)

  output$imgOutput2 <- renderImage({
    list(src = img_path2, style = "max-width:90%", alt = "Unit 2 nicht gefunden")
  }, deleteFile = FALSE)

  output$imgOutput3 <- renderImage({
    list(src = img_path3, style = "max-width:90%", alt = "Unit 3 nicht gefunden")
  }, deleteFile = TRUE) # Remove deleteFile argument
}

shinyApp(ui = ui, server = server)
