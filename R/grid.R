# library(shiny)
# #library(shinyGridster)
#
# ui <- fluidPage(
#   titlePanel("Hawaiianisches BirdWiki"),
#   gridsterOutput("imageGrid")
# )
#
# server <- function(input, output, session) {
#   # Erstellen Sie ein leeres Raster mit 3 Spalten
#   output$imageGrid <- renderGridster({
#     gridster(
#       rows = 6,  # Anzahl der Zeilen im Raster
#       columns = 3,  # Anzahl der Spalten im Raster
#       layout = list(
#         list(
#           col = 1,  # Startspalte des Bildes
#           row = 1,  # Startzeile des Bildes
#           size_x = 1,  # Breite des Bildes im Raster
#           size_y = 1  # Höhe des Bildes im Raster
#         )
#         # Hier sollten Sie Layoutinformationen für alle 174 Bilder hinzufügen
#       )
#     )
#   })
#
#   # Fügen Sie die Bilder mit renderImage hinzu
#   for (i in 1:174) {
#     output[[paste0("imageDisplay", i)]] <- renderImage({
#       list(
#         src = file.path("www", paste0("image", i, ".png")),
#         width = "100%",  # Sie können die Breite anpassen
#         height = "auto",  # Lassen Sie die Höhe automatisch anpassen
#         onclick = paste0("window.open('https://ebird.org/species/bird", i, "', '_blank')")
#       )
#     })
#   }
# }
#
# shinyApp(ui, server)
