library(base64enc)

server <- function(input, output){
  observeEvent( input$play_audio, {

    req( input$uploaded_audio )

    base64 <- dataURI(file = input$uploaded_audio$datapath, mime = "audio/wav")

    insertUI( selector = "#play_audio", where = "afterEnd",

              ui = tags$audio( src = base64, type = "audio/wav", autoplay = NA, controls = NA )
    )

  })
}
