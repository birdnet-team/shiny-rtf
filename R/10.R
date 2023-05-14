library(shiny)
#library(shinyFiles)
library(tuneR)

ui <- fluidPage(
  titlePanel("OGG to WAV Converter"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose an OGG file", accept = ".ogg")
    ),
    mainPanel(
      downloadButton("download", "Download WAV file")
    )
  )
)

server <- function(input, output) {
  observeEvent(input$file, {
    file <- input$file$datapath
    if (tolower(substr(file, nchar(file) - 2, nchar(file))) != "ogg") {
      showModal(modalDialog(
        title = "Error",
        "Please select an OGG file.",
        easyClose = TRUE,
        footer = NULL
      ))
    } else {
      output$download <- downloadHandler(
        filename = function() {
          paste0(gsub(".ogg", "", basename(file)), ".wav")
        },
        content = function(file) {
          ogg <- readWave(file)
          writeWave(ogg, file, extensible = FALSE)
        }
      )
    }
  })
}

shinyApp(ui, server)
