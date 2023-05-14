library(shiny)
library(tuneR)

ui <- fluidPage(
  fileInput("file", "Choose OGG file"),
  plotOutput("spectrogram"),
  verbatimTextOutput("debug")
)

server <- function(input, output) {
  observeEvent(input$file, {
    # Konvertieren Sie das hochgeladene OGG-File in ein WAV-File
    audio <- reactive({
      inFile <- input$file
      if (is.null(inFile)) {
        return(NULL)
      }
      system(paste("ffmpeg -i", shQuote(inFile$datapath), "-acodec pcm_s16le -ac 1 -ar 44100 -f wav audio.wav"))
      readWave("audio.wav")
    })

    # Überprüfen Sie, ob das WAV-File gefunden wurde
    if (!is.null(audio())) {
      # Überprüfen Sie, ob das WAV-File korrekt gelesen wird, indem Sie es abspielen
      debug <- paste("Audio duration:", round(duration(audio()), 2), "seconds")
      play(audio())

      # Erstellen Sie das Spektrogramm direkt mit der "spectrogram" -Funktion
      spectrogram <- spectrogram(audio(), wl = 256, ov = 128, plot = FALSE)

      # Überprüfen Sie, ob das Spektrogramm erfolgreich erstellt wurde
      if (is.null(spectrogram)) {
        debug <- paste(debug, "Error: Could not create spectrogram.")
        output$spectrogram <- renderText({
          "Error: Could not create spectrogram."
        })
      } else {
        output$spectrogram <- renderPlot({
          plot(spectrogram, main = "Spectrogram")
        })
      }
    } else {
      # Wenn das WAV-File nicht gefunden wurde, geben Sie eine Fehlermeldung aus
      debug <- paste("Error: WAV file not found.")
      output$spectrogram <- renderText({
        "Error: WAV file not found."
      })
    }
    output$debug <- renderPrint({
      debug
    })
  })
}

shinyApp(ui, server)
