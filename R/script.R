# # Server-Definition
# server <- function(input, output, session) {
#   output$wikipediaLink <- renderUI({
#     if (!is.null(input$openPage)) {
#       selectedVogel <- input$vogel
#       selectedBird <- unlist(strsplit(selectedVogel, ","))[[1]]  # Extract the bird name
#       # Find the Wikipedia link for the selected bird
#       selectedLink <- switch(selectedBird,
#                              "Acridotheres tristis_Common Myna" = "https://en.wikipedia.org/wiki/Common_myna",
#                              "Actitis hypoleucos_Common Sandpiper" = "https://en.wikipedia.org/wiki/Common_sandpiper",
#                              # Add more cases for other bird names
#                              # ...
#                              "Zosterops japonicus_Warbling White-eye" = "https://en.wikipedia.org/wiki/Warbling_white-eye",
#                              "DefaultLink" = "https://en.wikipedia.org/wiki/Main_Page"  # Default link if not found
#       )
#       tags$a(href = selectedLink, "Wikipedia-Seite öffnen")
#     } else {
#       "Wählen Sie einen Vogel aus und klicken Sie auf 'Wikipedia-Seite öffnen'."
#     }
#   })
# }
#
# # App erstellen
# shinyApp(ui, server)
#
