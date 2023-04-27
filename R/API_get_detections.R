library(shiny)
library(reactable)
library(httr2)
library(dplyr)
library(lubridate)

# Define API endpoint
API_ENDPOINT <- "https://birdnet.cornell.edu/api/"

# Define API key (replace with your own if you have one)
API_KEY <- ""

# Define function to make API request
get_detections <- function(lat, lon, radius, date_range) {
  query <- list(
    lat = lat,
    lon = lon,
    radius = radius,
    date_range = date_range
  )

  url <- modify_url(API_ENDPOINT, path = "detections/")
  res <- GET(url, query = query, add_headers("X-API-KEY" = API_KEY))
  res$status_code %>%
    stop_for_status()
  res$content %>%
    fromJSON()
}

# Define function to download audio file
download_audio <- function(url) {
  res <- GET(url)
  res$status_code %>%
    stop_for_status()
  tempfile() %>%
    writeBin(res$content) %>%
    file.rename(paste0("audio_", Sys.time(), ".wav"))
}

# Define UI
ui <- fluidPage(
  titlePanel("BirdNET API Demo"),
  sidebarLayout(
    sidebarPanel(
      numericInput("lat", "Latitude", value = 42.45),
      numericInput("lon", "Longitude", value = -76.48),
      numericInput("radius", "Radius (km)", value = 5),
      dateRangeInput("date_range", "Date Range", start = "2022-01-01", end = "2022-01-31"),
      actionButton("submit", "Submit")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Detections",
                 reactableOutput("table"),
                 downloadButton("download_audio_btn", "Download Audio")),
        tabPanel("JSON", verbatimTextOutput("json"))
      )
    )
  )
)

# Define server
server <- function(input, output, session) {
  detections <- reactive({
    req(input$submit)
    get_detections(input$lat, input$lon, input$radius, input$date_range)
  })

  output$table <- renderReactable({
    reactable(detections(),
              columns = list(
                common = colDef(name = "Species"),
                datetime = colDef(name = "Datetime"),
                audio_url = colDef(name = "Audio URL", hidden = TRUE)
              ),
              onClick = JS("function(rowInfo, column) {
                              if (column.id === 'audio_url') {
                                var audio_url = rowInfo.values[column.id];
                                Shiny.setInputValue('download_audio', audio_url);
                              }
                            }"))
  })

  output$json <- renderPrint({
    detections()
  })

  observeEvent(input$download_audio, {
    download_audio(input$download_audio)
  })
}

# Run the app
shinyApp(ui, server)
