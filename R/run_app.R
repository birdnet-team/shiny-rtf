#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  polished::polished_config(app_name = "BirdNETmonitor", api_key = "1AjI1zHTrL6k2C4qoTQg2aoN9DqcJRmTdc", cookie_expires = NULL)

  with_golem_options(
    app = shinyApp(
      ui = polished::secure_ui(app_ui), #app_ui,
      server = polished::secure_server(app_server), #app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
