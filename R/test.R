library(shiny)

ui <- fluidPage(
  titlePanel("Hawaiianisches BirdWiki"),
  fluidRow(
    lapply(1:174, function(i) {
      column(4, uiOutput(paste0("imageDisplay", i)))
    })
  )
)

server <- function(input, output, session) {
  ns <- session$ns

  for (i in 1:174) {
    output[[paste0("imageDisplay", i)]] <- renderImage({
      list(src = "www/logo.png", alt = paste("Image", i))
    })
  }
}

shinyApp(ui = ui, server = server)

