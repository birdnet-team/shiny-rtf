library(shiny)
install.packages("png")
library(png)

Callcam <- function(id) {
  ns <- NS(id)
  titlePanel("Download and display observation images")
  tagList(
    actionButton(ns("displayBtnUnit1"), "show Picture Unit 1"),
    actionButton(ns("displayBtnUnit2"), "show Picture Unit 2"),
    actionButton(ns("displayBtnUnit3"), "show Picture Unit 3"),
    uiOutput(ns("imageOutputUnit1")),
    uiOutput(ns("imageOutputUnit2")),
    uiOutput(ns("imageOutputUnit3"))
  )
}

callcam_server <- function(id, data, url) {
  moduleServer(id, function(input, output, session) {
    img_path1 <- "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/img1.png"
    img_path2 <- "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/img2.png"
    img_path3 <- "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/img3.png"

    urlUnit1 <- "http://viewer:birdnet2023!@166.148.48.130:8001/cgi-bin/image.jpg?imgprof=BirdNET"
    urlUnit2 <- "http://viewer:birdnet2023!@166.143.21.131:8001/cgi-bin/image.jpg?imgprof=BirdNET"
    urlUnit3 <- "http://viewer:birdnet2023!@166.148.204.108:8001/cgi-bin/image.jpg?imgprof=BirdNET"

    observeEvent(input$displayBtnUnit1, {
      if (input$displayBtnUnit1) {
        download.file(urlUnit1, img_path1, mode = "wb")
        output$imageOutputUnit1 <- renderUI({
          fluidRow(
            column(5, imageOutput("imgOutput1"))
          )
        })
      }
    })

    observeEvent(input$displayBtnUnit2, {
      if (input$displayBtnUnit2) {
        download.file(urlUnit2, img_path2, mode = "wb")
        output$imageOutputUnit2 <- renderUI({
          fluidRow(
            column(5, imageOutput("imgOutput2"))
          )
        })
      }
    })

    observeEvent(input$displayBtnUnit3, {
      if (input$displayBtnUnit3) {
        download.file(urlUnit3, img_path3, mode = "wb")
        output$imageOutputUnit3 <- renderUI({
          fluidRow(
            column(5, imageOutput("imgOutput3"))
          )
        })
      }
    })


    output$imgOutput1 <- renderImage({
      list(src = img_path1, style = "max-width:100%", alt = "Unit 1 nicht gefunden")
    }, deleteFile = FALSE)

    output$imgOutput2 <- renderImage({
      list(src = img_path2, style = "max-width:100%", alt = "Unit 2 nicht gefunden")
    }, deleteFile = FALSE)

    output$imgOutput3 <- renderImage({
      list(src = img_path3, style = "max-width:100%", alt = "Unit 3 nicht gefunden")
    }, deleteFile = FALSE)
  })
}


ui <- fluidPage(
  titlePanel("Real-Time Display of Observation Images from Units"),
  Callcam("callcamXX")
)

server <- function(input, output, session) {
  callcam_server("callcamXX", NULL, NULL)
}

shinyApp(ui = ui, server = server)
