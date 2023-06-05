library(shiny)
library(httr)
library(jsonlite)

mod_weather_ui <- function(id) {
  ns <- NS(id)
  tagList(
    textInput(ns("city"), label = "Enter City Name"),
    actionButton(ns("get_weather"), label = "Get Weather"),
    verbatimTextOutput(ns("weather_output"))
  )
}

mod_weather_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    get_weather_data <- function(city) {
      api_key <- "YOUR_API_KEY"  # Replace with your actual API key
      url <- paste0("http://api.weatherapi.com/v1/current.json?key=", api_key, "&q=", city)
      response <- httr::GET(url)
      data <- jsonlite::fromJSON(httr::content(response, "text"))
      return(data)
    }

    observeEvent(input$get_weather, {
      city <- input$city
      weather_data <- get_weather_data(city)
      output$weather_output <- renderPrint({
        weather_data
      })
    })
  })
}

