#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bs4Dash
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    dashboardPage(
      title = "Hawaii Monitoring",
      dark = NULL,
      dashboardHeader(
        title = dashboardBrand("Hawaii Monitoring", image = "www/logo-birdnet_icon.png"),
        compact = TRUE,
        rightUi =  mod_sign_out_ui("sign_out_1"),
        div(
          mod_get_data_daterange_ui("get_data_daterange_1"),
          style = "margin-bottom: -20px;"
        ),
        div(
          mod_set_timezone_ui("set_timezone_1"),
          style = "margin-bottom: -20px; margin-left: 12px"
        )
      ),
      dashboardSidebar(
        sidebarMenu(
          menuItem("Overview", tabName = "overview", icon = icon("home"))
        )
      ),
      dashboardBody(
        tabItems(
          tabItem(
            tabName = "overview",
            h4("Logs"),
            mod_status_overview_ui("status_overview_1"),
            h2(""),
            h4("Detections"),
            mod_detections_table_ui("detections_table_1")
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "BirdNETmonitor"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
