#' @importFrom shiny NS tagList
#' @import httr
#' @import png

Callcam <- function(id){
  ns <- NS(id)
  titlePanel("Real-Time Display of Observation Images from Units")

  mainPanel(

    actionButton(ns("displayBtnUnit1"), label = "show Picture Unit 1"),
    actionButton(ns("displayBtnUnit2"), label = "show Picture Unit 2"),
    actionButton(ns("displayBtnUnit3"), label = "show Picture Unit 3"),

    uiOutput(ns("imageOutputUnit1")),
    uiOutput(ns("imageOutputUnit2")),
    uiOutput(ns("imageOutputUnit3"))
  )


}

callcam_server <- function(id, data) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns
#
#     img_path1 <- "img1.png"
#     img_path2 <- "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/R/img2.png"
#     img_path3 <- "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/img3.png"

    urlUnit1 <- "http://viewer:birdnet2023!@166.148.48.130:8001/cgi-bin/image.jpg?imgprof=BirdNET"
    urlUnit2 <- "http://viewer:birdnet2023!@166.143.21.131:8001/cgi-bin/image.jpg?imgprof=BirdNET"
    urlUnit3 <- "http://viewer:birdnet2023!@166.148.204.108:8001/cgi-bin/image.jpg?imgprof=BirdNET"

    observeEvent(input$displayBtnUnit1, {
      download.file(urlUnit1, "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/R/img1.png", mode = "wb")
      output$imageOutputUnit1 <- renderUI({
        fluidRow(
          column(5, imageOutput("imgOutput1"))
        )
      })
    })

    observeEvent(input$displayBtnUnit2, {
      download.file(urlUnit2, "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/R/img2.png", mode = "wb")
      output$imageOutputUnit2 <- renderUI({
        fluidRow(
          column(5, imageOutput("imgOutput2"))
        )
      })
    })

    observeEvent(input$displayBtnUnit3, {
      download.file(urlUnit3, "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/R/img3.png", mode = "wb")
      output$imageOutputUnit3 <- renderUI({
        fluidRow(
          column(5, imageOutput("imgOutput3"))
        )
      })
    })

    output$imgOutput1 <- renderImage({
      list(src = img_path1,
           style = "max-width:100%",
           alt = "Unit 1 nicht gefunden")
    }, deleteFile = FALSE)

    output$imgOutput2 <- renderImage({
      list(src = img_path2,
           style = "max-width:100%",
           alt = "Unit 2 nicht gefunden")
    }, deleteFile = FALSE)

    output$imgOutput3 <- renderImage({
      list(src = img_path3,
           style = "max-width:100%",
           alt = "Unit 3 nicht gefunden")
    }, deleteFile = FALSE)


 })
}
