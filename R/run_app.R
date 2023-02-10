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
){
  polished::polished_config(
    app_name = "BirdNETmonitor",
    api_key = "1AjI1zHTrL6k2C4qoTQg2aoN9DqcJRmTdc",
    cookie_expires = NULL
  )
  my_custom_sign_in_page <- sign_in_ui_default(
    sign_in_module = sign_in_module_ui("sign_in", register_link = NULL),
    color = "#999999",
    company_name = "BirdNET Monitoring",
    logo_top = tags$img(
      src = "www/logo-birdnet_monitoring_web_112x112-01.png",
      alt = "Logo: BirdNET",
      style = "width: 155px; margin-top: 30px; margin-bottom: 30px;"
    ),
    logo_bottom = tags$img(
      src = "www/Logo-The CornellLab_KLYCCB-01.png",
      alt = "Logo: The CornellLab_KLYCCB-01.png",
      style = "width: 200px; margin-bottom: 15px; padding-top: 15px;"
    ),
    icon_href = "www/logo-birdnet_icon.png",
    #background_image = "www/logo-birdnet_icon.png"
  )

  with_golem_options(
    app = shinyApp(
      ui = polished::secure_ui(app_ui,sign_in_page_ui = my_custom_sign_in_page), #app_ui,
      server = polished::secure_server(app_server), #app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )

}


