library(shiny)
install.packages("png")
library(png)

Callcam <- function(id) {
  ns <- NS(id)
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
    img_path1 <- "img1.png"
    img_path2 <- "img2.png"
    img_path3 <- "img3.png"

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
        download_done <- FALSE
        download.file(urlUnit3, img_path3, mode = "wb", quiet = TRUE,
                      method = "libcurl",
                      progress = function(e) {
                        total <- e$total
                        downloaded <- e$downloaded
                        percent <- round(downloaded / total * 100, 2)
                        cat(paste("Download progress: ", percent, "%\n"))
                        flush.console()
                      },
                      done = function(file) {
                        download_done <- TRUE
                      }
        )
      }
    })

    #     output$imageOutputUnit3 <- renderImage({
    #       if (download_done) {
    #         fluidRow(
    #           column(5, imageOutput("imgOutput3"))
    #         )
    #       } else {
    #         div("Download in Bearbeitung...")
    #       }
    #     })
    #   }
    # })


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

# ui <- fluidPage(
#   titlePanel("Download and Display observation images"),
#   callcam("cameraModule")
#   #callcam("appCallCamXXMWR")
# )
#
# server <- function(input, output, session) {
#   CallcamServer("cameraModule", NULL, NULL)
# }
#
# shinyApp(ui = ui, server = server)
