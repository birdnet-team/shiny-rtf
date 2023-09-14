#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(onStart = NULL,
                    options = list(),
                    enableBookmarking = NULL,
                    uiPattern = "/",
                    ...) {
  addResourcePath("www", system.file("app/www", package = "BirdNETmonitor"))

  with_golem_options(
    app = shinyApp(
      ui = shinymanager::secure_app(
        app_ui,
        background = "#999999",
        tags_top = tags$img(
          src = "www/logo-birdnet_monitoring_XX-03_ocean_blue_fonted-01-01.png",
          alt = "Logo: BirdNET",
          style = "width: 155px; margin-top: 30px; margin-bottom: 30px;"
        ),
        tags_bottom = div(style = "text-align: center;", tags$img(
          src = "www/Logo-The CornellLab_KLYCCB-01.png",
          alt = "Logo: The CornellLab_KLYCCB-01.png",
          style = "width: 200px; margin-bottom: 15px; padding-top: 15px;"
        ))
      ),
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
