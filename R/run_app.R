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
        # status = "primary btn-lg",
        head_auth = tagList(
          tags$style(
            "* {
              text-align: center;
            }"
          ),
          tags$style(
            ".panel {
               -webkit-box-shadow:none;
               box-shadow:2px 2px 8px 1px gray;
            }"
          ),
          tags$style(
            ".panel-primary {
              border-color:#4582ec00;
            }"
          ),
          # tags$style(
          #   "#auth-shinymanager-auth-head {
          #     visibility: hidden;
          #     position: relative;
          #     margin-top: 0px;
          #     margin-botton: 0px;
          #   }"
          # ),
          tags$style(
            "#auth-shinymanager-auth-head {
              display: none;
            }"
          ),
          tags$style(
            ".form-group.shiny-input-container {
              width: 100%;
              display: grid;
              justify-content: center;
            }"
          ),
          tags$style(
            "#auth-go_auth {
              width: 30% !important;
            }"
          )
        ),
        tags_top = tags$img(
          src = "www/logo-birdnet_new.png",
          alt = "Logo: BirdNET",
          style = "width: 200px; margin-top: 15px; margin-bottom: 30px;"
        ),
        tags_bottom = div(style = "text-align: center;", tagList(
          tags$img(
            src = "www/Logo-The CornellLab_KLYCCB-01.png",
            alt = "Logo: The CornellLab_KLYCCB-01.png",
            style = "width: 200px; margin-bottom: 10px; padding-top: 10px;"
          ),
          tags$img(
            src = "www/KHS TUC farbig eng.png",
            style = "width: 200px; margin-bottom: 10px; padding-top: 10px"
          )
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
