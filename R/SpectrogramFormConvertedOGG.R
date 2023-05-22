library(shiny)
library(av)
library(seewave)
library(tuneR)

ui <- fluidPage(
  titlePanel("Audio Converter"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Wähle eine OGG-Datei aus")
    ),
    mainPanel(
      plotOutput("spectrogram"),
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

      output$spectrogram <- renderPlot({
        wav <- readWave(wav_file)
        spectro(wav, f = 16000, wl = 1024, wn = "hanning", ovlp = 50, collevels = seq(-80, 0,1), palette= temp.colors, grid=FALSE, colbg = "black", collab="white", colaxis = "white", fftw = TRUE, flog = TRUE, noisereduction = 2)
      })

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
