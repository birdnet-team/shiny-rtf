library(shiny)
library(tuneR)
library(seewave)

# UI erstellen
ui <- fluidPage(
  fileInput("file_input", "Choose an OGG audio file"),
  plotOutput("spectrogram_plot")
)

# Server erstellen
server <- function(input, output) {
  # Spektrogramm anzeigen, wenn eine Datei ausgewählt wird
  observeEvent(input$file_input, {
    # OGG-Datei lesen und in WAV-Datei konvertieren
    audio <- readOGG(input$file_input$datapath)
    audio_wav <- as(audio, "Wave")

    # Spektrogramm berechnen und anzeigen
    spectro <- spec(audio_wav, f = audio_wav@samp.rate, wl = 1024, ov = 512, window = "hanning")
    output$spectrogram_plot <- renderPlot({
      plot(spectro, log = "dB", col = heat.colors(256))
    })
  })
}

# App starten
shinyApp(ui = ui, server = server)
