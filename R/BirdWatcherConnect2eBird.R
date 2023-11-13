#' @importFrom shiny NS tagList
#' @import httr
#' @import png

library(shinyjs)

Wiki <- function(id) {
  fluidPage(
    titlePanel("Hawaiian Birdwatching Encyclopedia"),
    fluidRow(
      column(2, imageOutput("imageDisplay1", click = "image_click1")),
      column(2, imageOutput("imageDisplay2", click = "image_click2")),
      column(2, imageOutput("imageDisplay3", click = "image_click3"))

    ),
    useShinyjs()
  )
}

wiki_server <- function(id, data) {
  moduleServer( id, function(input, output, session){

    image_data <- data.frame(
      image_path = c(
        "BirdNETmonitor/BirdWatcherImages/1_Amandava_amandava_Red_Avadavat.png",
        "BirdNETmonitor/BirdWatcherImages/2_Northern_Pintails_(Male_&_Female)_I_IMG_0911.png",
        "BirdNETmonitor/BirdWatcherImages/3_Green-winged_Teal,_Port_Aransas,_Texas.png"

      ),
      link = c(
        "https://ebird.org/species/redava",
        "https://de.wikipedia.org/wiki/Vogel2",
        "https://de.wikipedia.org/wiki/Vogel3"

      )
    )

    for (i in 1:3) {
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

shinyApp(Wiki, wiki_server)
