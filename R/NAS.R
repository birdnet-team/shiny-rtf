library(shiny)
library(R.utils)

ui <- fluidPage(
  titlePanel("NAS Zugriff mit Shiny"),
  sidebarLayout(
    sidebarPanel(
      textInput("nas_path", "Pfad zur Datei auf NAS:", value = "https://reco.birdnet.tucmi.de/reco/BirdNET-HI001/Camera/2023-08-23/HI001_Cam1_2023-08-23_16-10-01.jpg"),
      actionButton("read_button", "Datei lesen") #HI001_Cam1_2023-08-23_16-10-01.jpg
    ),
    mainPanel(
      verbatimTextOutput("file_content")
    )
  )
)

server <- function(input, output) {

  # Event handler für den Button-Klick
  observeEvent(input$read_button, {

    # NAS Verbindung herstellen
    nas_conn <- file.createNFSConnection(
      server = "http://pelican.informatik.tu-chemnitz.de:5000/",
      share = "backup",
      username = "micloud",
      password = "S9aNsqvV"
    )

    # Datei vom NAS lesen
    file_content <- readLinesNFS(input$nas_path, connection = nas_conn)

    # NAS Verbindung trennen
    file.closeNFSConnection(nas_conn)

    # Den Inhalt der Datei anzeigen
    output$file_content <- renderPrint({
      cat(file_content, sep = "\n")
    })
  })
}

shinyApp(ui = ui, server = server)
