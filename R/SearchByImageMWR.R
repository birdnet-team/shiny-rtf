library(shiny)
library(rvest)
library(shinyjs)

# Shiny-UI
ui <- fluidPage(
  titlePanel("Vogelbilder und Wikipedia-Links"),
  sidebarLayout(
    sidebarPanel(
      # Hier können Sie weitere Steuerelemente hinzufügen, wenn nötig
    ),
    mainPanel(
      # Hier werden die Bilder und Links angezeigt
      uiOutput("bird_images_html")
    )
  )
)

# Shiny-Server
server <- function(input, output, session) {
  # Die bird_data-Daten
  bird_data <- read.table(text = "Name Links
Fulica_alai_Hawaiian_Coot https://en.wikipedia.org/wiki/Hawaiian_coot
Gallinula_galeata_Common_Gallinule https://en.wikipedia.org/wiki/Common_gallinule
Gallus_gallus_Red_Junglefowl https://en.wikipedia.org/wiki/Red_junglefowl
# ... (andere Vogelarten)
Zosterops_japonicus_Warbling_White-eye https://en.wikipedia.org/wiki/Japanese_white-eye", header = TRUE, stringsAsFactors = FALSE)

  # Funktion zum Abrufen von Bildern und Links von Wikipedia
  scrape_wikipedia <- function(bird_name, bird_link) {
    bird_page <- read_html(bird_link)
    image_url <- bird_page %>%
      html_nodes(".image img") %>%
      html_attr("src") %>%
      .[1]
    return(image_url)
  }

  # Generieren Sie den HTML-Code für die Vogelbilder und Links
  generate_bird_image_html <- function(bird_data) {
    bird_html <- lapply(seq(nrow(bird_data)), function(i) {
      bird_name <- bird_data$Name[i]
      bird_link <- bird_data$Links[i]
      image_url <- scrape_wikipedia(bird_name, bird_link)
      bird_html <- sprintf(
        '<a href="%s" target="_blank"><img id="%s" class="bird-image" src="%s" alt="%s" width="200" height="150"></a>',
        bird_link, bird_name, image_url, bird_name
      )
      return(bird_html)
    })
    return(bird_html)
  }

  # Rendern Sie den HTML-Code
  bird_image_html <- generate_bird_image_html(bird_data)
  output$bird_images_html <- renderUI({
    HTML(paste(bird_image_html, collapse = "<br>"))
  })

  # Reagieren auf Bildklicks und öffnen Sie Wikipedia-Seiten
  observe({
    for (i in 1:nrow(bird_data)) {
      bird_name <- bird_data$Name[i]
      bird_link <- bird_data$Links[i]
      shinyjs::onclick(paste0("#", bird_name), {
        js$window$open(bird_link)
      })
    }
  })
}

shinyApp(ui = ui, server = server)
