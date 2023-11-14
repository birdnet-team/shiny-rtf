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
      column(2, imageOutput("imageDisplay7", click = "image_click7")),
      column(2, imageOutput("imageDisplay8", click = "image_click8")),
      column(2, imageOutput("imageDisplay9", click = "image_click9")),
      column(2, imageOutput("imageDisplay10", click = "image_click10")),
      column(2, imageOutput("imageDisplay11", click = "image_click11")),
      column(2, imageOutput("imageDisplay12", click = "image_click12")),
      column(2, imageOutput("imageDisplay13", click = "image_click13")),
      column(2, imageOutput("imageDisplay14", click = "image_click14")),
      column(2, imageOutput("imageDisplay15", click = "image_click15")),
      column(2, imageOutput("imageDisplay16", click = "image_click16")),
      column(2, imageOutput("imageDisplay17", click = "image_click17")),
      column(2, imageOutput("imageDisplay18", click = "image_click18")),
      column(2, imageOutput("imageDisplay19", click = "image_click19")),
      column(2, imageOutput("imageDisplay20", click = "image_click20")),
      column(2, imageOutput("imageDisplay21", click = "image_click21")),
      column(2, imageOutput("imageDisplay22", click = "image_click22")),
      column(2, imageOutput("imageDisplay23", click = "image_click23")),
      column(2, imageOutput("imageDisplay24", click = "image_click24")),
      column(2, imageOutput("imageDisplay25", click = "image_click25")),
      column(2, imageOutput("imageDisplay26", click = "image_click26")),
      column(2, imageOutput("imageDisplay27", click = "image_click27")),
      column(2, imageOutput("imageDisplay28", click = "image_click28")),
      column(2, imageOutput("imageDisplay29", click = "image_click29")),
      column(2, imageOutput("imageDisplay30", click = "image_click30"))
    ),
    useShinyjs()
  )
}

wiki_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {

    image_data <- data.frame(
      image_path = c(
        "BirdNETmonitor/BirdWatcherImages/1_Amandava_amandava_Red_Avadavat.png",
        "BirdNETmonitor/BirdWatcherImages/2_Northern_Pintails_(Male_&_Female)_I_IMG_0911.png",
        "BirdNETmonitor/BirdWatcherImages/3_Green-winged_Teal,_Port_Aransas,_Texas.png",
        "BirdNETmonitor/BirdWatcherImages/Anas platyrhynchos_Mallard.png",
        "BirdNETmonitor/BirdWatcherImages/Anous minutus_Black Noddy.png",
        "BirdNETmonitor/BirdWatcherImages/Anous stolidus_Brown Noddy.png",
        "BirdNETmonitor/BirdWatcherImages/Anser albifrons_Greater White-fronted Goose.png",
        "BirdNETmonitor/BirdWatcherImages/Anser caerulescens_Snow Goose.png",
        "BirdNETmonitor/BirdWatcherImages/Ardea herodias_Great Blue Heron.png", #9
        "BirdNETmonitor/BirdWatcherImages/Ardenna grisea_Sooty Shearwater.png",
        "BirdNETmonitor/BirdWatcherImages/Ardenna pacifica_Wedge-tailed Shearwater.png", #11
        # Add other image paths here...
      ),
      link = c(
        "https://ebird.org/species/redava",
        "https://ebird.org/species/norpin",
        "https://ebird.org/species/gnwtea",
        "https://ebird.org/species/mallar3/L2557088",
        "https://ebird.org/species/blknod/L1657549",
        "https://ebird.org/species/brnnod",
        "https://ebird.org/species/gwfgoo",
        "https://ebird.org/species/snogoo",
        "https://ebird.org/species/grbher3", #9
        "https://ebird.org/species/sooshe",
        "https://ebird.org/species/wetshe", #11
        # Add other links here...
      )
    )

    for (i in 1:nrow(image_data)) {
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
