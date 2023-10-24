# library(shiny)
# library(httr)
# library(png)
#
# Callcam <- fluidPage(
#   titlePanel("Real-Time Display of Observation Images from Units"),
#
#   mainPanel(
#     actionButton("displayBtnUnit1", "show Picture Unit 1"),
#     actionButton("displayBtnUnit2", "show Picture Unit 2"),
#     actionButton("displayBtnUnit3", "show Picture Unit 3"),
#     uiOutput("imageOutputUnit1"),
#     uiOutput("imageOutputUnit2"),
#     uiOutput("imageOutputUnit3")
#   )
# )
#
# callcam_server <- function(input, output) {
#   img_path1 <- "img1.png"
#   img_path2 <- "img2.png"
#   img_path3 <- "img3.png"
#
#   urlUnit1 <- "http://viewer:birdnet2023!@166.148.48.130:8001/cgi-bin/image.jpg?imgprof=BirdNET"
#   urlUnit2 <- "http://viewer:birdnet2023!@166.143.21.131:8001/cgi-bin/image.jpg?imgprof=BirdNET"
#   urlUnit3 <- "http://viewer:birdnet2023!@166.148.204.108:8001/cgi-bin/image.jpg?imgprof=BirdNET"
#
#   observeEvent(input$displayBtnUnit1, {
#     download.file(urlUnit1, "img1.png", mode = "wb")
#     output$imageOutputUnit1 <- renderUI({
#       fluidRow(
#         column(5, imageOutput("imgOutput1"))
#       )
#     })
#   })
#
#   observeEvent(input$displayBtnUnit2, {
#     download.file(urlUnit2, "img2.png", mode = "wb")
#     output$imageOutputUnit2 <- renderUI({
#       fluidRow(
#         column(5, imageOutput("imgOutput2")
#         )
#       )
#     })
#   })
#
#   observeEvent(input$displayBtnUnit3, {
#     download.file(urlUnit3, "img3.png", mode = "wb")
#     output$imageOutputUnit3 <- renderUI({
#       fluidRow(
#         column(5, imageOutput("imgOutput3"),
#         )
#       )
#     })
#   })
#
#
#   output$imgOutput1 <- renderImage({
#     list(src = img_path1,
#          style = "max-width:100%",
#          alt = "Unit 1 nicht gefunden")
#   }, deleteFile = FALSE)
#
#   output$imgOutput2 <- renderImage({
#     list(src = img_path2,
#          style = "max-width:100%",
#          alt = "Unit 2 nicht gefunden")
#   }, deleteFile = FALSE)
#
#   output$imgOutput3 <- renderImage({
#     list(src = img_path3,
#          style = "max-width:100%",
#          alt = "Unit 3 nicht gefunden")
#   }, deleteFile = FALSE)
# }
#
# #shinyApp(Callcam, callcam_server)
