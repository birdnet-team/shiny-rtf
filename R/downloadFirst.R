# Install and load required packages
if (!require("shiny")) install.packages("shiny")
if (!require("shinyjs")) install.packages("shinyjs")

library(shiny)
library(shinyjs)

img1 <- function(src, alt, style = "") {
  tags$img(src = src, alt = alt, style = style)
}

# Shiny App Definition
Wiki <- function(id, image_paths) {
  ns <- NS(id)

  fluidPage(
    titlePanel("Hawaiian Birdwatching Encyclopedia -- work in progress mwrxx999"),
    useShinyjs(),
    fluidRow(
      lapply(seq_along(image_paths), function(i) {
        image_path <- image_paths[i]
        tagList(
          img1(src = image_path, alt = paste0("image", i), style = "width:300px;height:300px;"),
          uiOutput(ns(paste0("image_output", i)))
        )
      })
    )
  )
}

wiki_server <- function(id, image_paths) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    print(image_paths)  # Add this line to print image paths

    for (i in seq_along(image_paths)) {
      output[[ns(paste0("image_output", i))]] <- renderImage({
        list(src = image_paths[i], alt = paste0("Bild ", i, " nicht gefunden"))
      }, deleteFile = FALSE)
    }
  })
}

# ... (previous code)

# Get image files dynamically from the www folder
image_paths <- list.files("www", full.names = TRUE, pattern = "\\.(png|jpg|jpeg|gif|bmp)$")

# Print the list of image paths
print(image_paths)

# Create Shiny app
shinyApp(
  ui = Wiki("wiki", image_paths = image_paths),
  server = function(input, output, session) {
    wiki_server("wiki", image_paths = image_paths)
  }
)
