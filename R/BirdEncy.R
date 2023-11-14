library(shiny)
library(shinyjs)

Wiki <- function(id) {
  ns <- NS(id)

  fluidPage(
    titlePanel("Hawaiian Birdwatching Encyclopedia"),
    fluidRow(
      lapply(1:11, function(i) {
        column(2, imageOutput(ns(paste0("imageDisplay", i))))
      })
    ),
    useShinyjs()
  )
}

wiki_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    image_paths <- c(
      "BirdNETmonitor/BirdWatcherImagesXX/1_Amandava_amandava_Red_Avadavat.png",
      "BirdNETmonitor/BirdWatcherImagesXX/2_Northern_Pintails_(Male_&_Female)_I_IMG_0911.png",
      "BirdNETmonitor/BirdWatcherImagesXX/3_Green-winged_Teal,_Port_Aransas,_Texas.png",
      "BirdNETmonitor/BirdWatcherImagesXX/Anas platyrhynchos_Mallard.png",
      "BirdNETmonitor/BirdWatcherImagesXX/Anous minutus_Black Noddy.png",
      "BirdNETmonitor/BirdWatcherImagesXX/Anous stolidus_Brown Noddy.png",
      "BirdNETmonitor/BirdWatcherImagesXX/Anser albifrons_Greater White-fronted Goose.png",
      "BirdNETmonitor/BirdWatcherImagesXX/Anser caerulescens_Snow Goose.png",
      "BirdNETmonitor/BirdWatcherImagesXX/Ardea herodias_Great Blue Heron.png",
      "BirdNETmonitor/BirdWatcherImagesXX/Ardenna grisea_Sooty Shearwater.png",
      "BirdNETmonitor/BirdWatcherImagesXX/Ardenna pacifica_Wedge-tailed Shearwater.png"
    )

    bird_links <- c(
      "https://ebird.org/species/redava",
      "https://ebird.org/species/norpin",
      "https://ebird.org/species/gnwtea",
      "https://ebird.org/species/mallard",
      "https://ebird.org/species/blackno",
      "https://ebird.org/species/brownno",
      "https://ebird.org/species/whifro",
      "https://ebird.org/species/snowgo",
      "https://ebird.org/species/grebhe",
      "https://ebird.org/species/sooshe",
      "https://ebird.org/species/wetshe"
    )

    for (i in 1:11) {
      output[[paste0("imageDisplay", i)]] <- renderImage({
        list(src = image_paths[i], height = 300)
      })

      observeEvent(input[[paste0("imageDisplay", i)]], {
        shinyjs::enable(ns(paste0("imageDisplay", i)))
        shinyjs::onclick(
          selector = paste0("#", ns(paste0("imageDisplay", i))),
          code = sprintf('window.open("%s", "_blank");', bird_links[i]),
          delete_file = FALSE
        )
      })
    }
  })
}

shinyApp(Wiki, wiki_server)
