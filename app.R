# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file

pkgload::load_all(export_all = FALSE, helpers = FALSE, attach_testthat = FALSE)
options("golem.app.prod" = TRUE)

# Hier wird die Shiny-App initialisiert
shiny_app <- BirdNETmonitor::run_app() # fügen Sie hier ggf. Parameter hinzu

# Hier wird das Shiny-Objekt zurückgegeben
shiny_app
