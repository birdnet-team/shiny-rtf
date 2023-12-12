#' @importFrom shiny NS tagList
#' @import httr
#' @import png

Callcam <- function(id){
  ns <- NS(id)



  mainPanel(

    titlePanel("Real-Time Display of Observation Images from Units"),
    titlePanel(h1("Please note that the units are switched off between 6:00 pm and 8:00 am. No photo recording can be transmitted during this time.", style = "color: black; font-size: 18px;")),
    actionButton(ns("displayBtnUnit1"), label = "show Picture Unit 1"),
    actionButton(ns("displayBtnUnit2"), label = "show Picture Unit 2"),
    actionButton(ns("displayBtnUnit3"), label = "show Picture Unit 3"),

    fluidRow(
      column(11, uiOutput(ns("imageOutputUnit1"))),
      column(11, uiOutput(ns("imageOutputUnit2"))),
      column(11, uiOutput(ns("imageOutputUnit3")))
    )
  )
}

callcam_server <- function(id, data) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    urlUnit1 <- "http://viewer:birdnet2023!@166.148.48.130:8001/cgi-bin/image.jpg?imgprof=BirdNET"
    urlUnit2 <- "http://viewer:birdnet2023!@166.143.21.131:8001/cgi-bin/image.jpg?imgprof=BirdNET"
    urlUnit3 <- "http://viewer:birdnet2023!@166.148.204.108:8001/cgi-bin/image.jpg?imgprof=BirdNET"


    # img_path1 = "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonito/R"
    # img_path2 = "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonito/R"
    # img_path3 = "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonito/R"


    observeEvent(input$displayBtnUnit1, {
      return_code <- download_png(urlUnit1)
      output$imageOutputUnit1 <- renderUI({
        validate(
          need(return_code$success, return_code$value)
        )
        output$imgOutput1 <- renderImage({
          list(src = return_code$value,
               style = "max-width:100%",
               alt = "Unit 1 nicht gefunden")
        }, deleteFile = FALSE)
      })
    })

    observeEvent(input$displayBtnUnit2, {
      return_code <- download_png(urlUnit2)
      output$imageOutputUnit1 <- renderUI({
        validate(
          need(return_code$success, return_code$value)
        )
        output$imgOutput2 <- renderImage({
          list(src = img_path2,
               style = "max-width:100%",
               alt = "Unit 2 nicht gefunden")
        }, deleteFile = FALSE)
      })
    })

    observeEvent(input$displayBtnUnit3, {
      return_code <- download_png(urlUnit3)
      output$imageOutputUnit1 <- renderUI({
        validate(
          need(return_code$success, return_code$value)
        )
        output$imgOutput3 <- renderImage({
          list(src = img_path3,
               style = "max-width:100%",
               alt = "Unit 3 nicht gefunden")
        }, deleteFile = FALSE)
      })
    })

  })
}

# Create Shiny app
#shinyApp(ui = Callcam, server = callcam_server)

