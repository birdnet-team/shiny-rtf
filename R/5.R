library(shiny)
library(audio)

# Define UI
ui <- fluidPage(
  fileInput("input_file", "Enter path to wav file"),
  actionButton("convert_btn", "Convert to WAV"),
  downloadButton("download_btn", "Download WAV"),
  verbatimTextOutput("message")
)

# Define server
server <- function(input, output) {
  # Perform conversion when button is clicked
  observeEvent(input$convert_btn, {
    input_file <- input$input_file

    # Check if file exists
    if (!file.exists(input_file)) {
      output$message <- renderText("Error: File not found.")
      return()
    }

    # Convert Ogg to WAV
    output_file <- paste0(tools::file_path_sans_ext(input_file), ".wav")
    audio_convert(input_file, output_file, from = "wav", to = "wav")

    output$message <- renderText("Conversion complete.")

    # Enable download button
    output$download_btn$disabled <- FALSE
    output$download_btn$label <- "Download WAV"
    output$download_btn$href <- output_file
  })

  # Disable download button until conversion is complete
  output$download_btn <- downloadButton(
    "download_btn", "Converting...", disabled = TRUE
  )
}

# Run the app
shinyApp(ui = ui, server = server)
