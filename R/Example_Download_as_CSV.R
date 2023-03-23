## Only run examples in interactive R sessions
if (interactive()) {

  ui <- fluidPage(
    downloadLink("downloadData", "Download")
  )

  server <- function(input, output) {
    # Our dataset
    data <- mtcars

    output$downloadData <- downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), "sound_data_as_csv.csv", sep="")
      },
      content = function(file) {
        write.csv(data, file)
      }
    )
  }

  shinyApp(ui, server)
}
