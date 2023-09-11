library(shiny)
library(shinyFiles)
library(jpeg)
library(R.utils)

ui <- fluidPage(
  titlePanel("Sichere NAS Bildanzeige"),
  textOutput("output_text"),
  fileInput("image_upload", "Wähle ein Bild (JPG) vom NAS aus:", accept = c(".jpg", ".jpeg")),
  mainPanel(
    uiOutput("image_preview")
  )
)

server <- function(input, output) {

  nas_username <- Sys.getenv("micloud")
  nas_password <- Sys.getenv("S9aNsqvV")

  observeEvent(input$image_upload, {
    if (!is.null(input$image_upload)) {
      nas_path <- input$image_upload$datapath

      nas_server_address <- "http://pelican.informatik.tu-chemnitz.de:5000/"  # Hier die Adresse deines NAS-Servers eintragen

      nas_conn <- file.createNFSConnection(
        server = nas_server_address,
        share = "backup",
        username = nas_username,
        password = nas_password
      )

      tmp_file <- tempfile(fileext = ".jpg")
      save_file <- save_uploaded_file(input$image_upload, tmp_file)

      if (save_file) {
        img <- tags$img(src = tmp_file, width = "100%")
        output$image_preview <- renderUI({
          img
        })

        output$output_text <- renderText({
          "Bild vom NAS erfolgreich geladen!"
        })
      } else {
        output$output_text <- renderText({
          "Fehler beim Speichern des Bilds."
        })
      }

      file.closeNFSConnection(nas_conn)
    }
  })
}

shinyApp(ui = ui, server = server)
