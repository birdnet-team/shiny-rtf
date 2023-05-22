library(shiny)
library(av)

ui <- fluidPage(
  titlePanel("Audio Converter"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Wähle eine OGG-Datei aus")
    ),
    mainPanel(
      downloadButton("download", "Download WAV-Datei")
    )
  )
)

server <- function(input, output) {
  observeEvent(input$file, {
    inFile <- input$file

    if (!is.null(inFile)) {
      wav_file <- tempfile(fileext = ".wav")

      av_audio_convert(
        inFile$datapath,
        output = wav_file,
        format = "wav",
        verbose = TRUE
      )

      output$download <- downloadHandler(
        filename = function() {
          paste0(tools::file_path_sans_ext(inFile$name), ".wav")
        },
        content = function(file) {
          file.copy(wav_file, file)
        }
      )
    }
  })
}

shinyApp(ui, server)
