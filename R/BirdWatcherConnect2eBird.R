library(shiny)
library(shinyjs)

Wiki <- function(id) {
  fluidPage(
    titlePanel("Hawaiian Birdwatching Encyclopedia"),
    fluidRow(
      column(2, imageOutput("imageDisplay1", click = "image_click1")),
      column(2, imageOutput("imageDisplay2", click = "image_click2")),
      column(2, imageOutput("imageDisplay3", click = "image_click3")),
      column(2, imageOutput("imageDisplay4", click = "image_click4")),
      column(2, imageOutput("imageDisplay5", click = "image_click5")),
      column(2, imageOutput("imageDisplay6", click = "image_click6")),
      column(2, imageOutput("imageDisplay7", click = "image_click7"))
    ),
    useShinyjs()
  )
}

wiki_server <- function(id, data) {
  moduleServer( id, function(input, output, session){

  image_data <- data.frame(
    image_path = c(
      "C:/Users/ElementXX/Desktop/RSTudioNshinYXX888/FrontEnd999XX/MRWFrontE999XX/BirdNETmonitor/www/Amandava_amandava_Red_Avadavat.png",
      "www/second_image.png",
      "www/third_image.png",
      "www/fourth_image.png",
      "www/fifth_image.png",
      "www/sixth_image.png",
      "www/seventh_image.png"
    ),
    link = c(
      "https://de.wikipedia.org/wiki/Vogel1",
      "https://de.wikipedia.org/wiki/Vogel2",
      "https://de.wikipedia.org/wiki/Vogel3",
      "https://de.wikipedia.org/wiki/Vogel4",
      "https://de.wikipedia.org/wiki/Vogel5",
      "https://de.wikipedia.org/wiki/Vogel6",
      "https://de.wikipedia.org/wiki/Vogel7"
    )
  )

  for (i in 1:7) {
    image_id <- paste0("imageDisplay", i)
    observeEvent(input[[paste0("image_click", i)]], {
      url <- image_data$link[i]
      shinyjs::runjs(paste0("window.open('", url, "', '_blank');"))
    })

    output[[image_id]] <- renderImage({
      list(src = image_data$image_path[i], height = 300)
    }, deleteFile = FALSE)
  }


  })
}

#shinyApp(ui = Wiki(), server = wiki_server)
