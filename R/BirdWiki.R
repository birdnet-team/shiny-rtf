library(shiny)

targetURL <- "https://ebird.org/species/hawgoo"

ui <- fluidPage(
  titlePanel("BirdWiki-App"),
  mainPanel(
    uiOutput("imageDisplay")
  )
)

server <- function(input, output, session) {
  output$imageDisplay <- renderUI({
    img(src = "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/inst/app/www/1_A_pair_of_Red_avadavat_(Amandava_amandava)_Photograph_by_Shantanu_Kuveskar.png", width = "300px", height = "300px", click = "openLink")
  })

  observeEvent(input$openLink, {
    jscode <- sprintf("window.open('%s', '_blank');", targetURL)
    session$sendCustomMessage("jsCode", list(code = jscode))
  })
}

shinyApp(ui, server)
