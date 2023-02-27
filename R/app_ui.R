library(ggplot2)
library(shiny)
library(shinyjs)
library(shinyBS)
library(shinyFiles)
library(shinythemes)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
#install(shinyThings)
#library(shinyThings)#for undo
library(keys)
library(imola)
library(tuneR)
library(seewave) # for spectrogram
#library(plotly)
#library(oce)
library(viridis)
#library(grid)
#library(gridExtra)
#library(cowplot) # to get legend
#library(reactlog) # view all connections for reactive objects
library(profvis) # for checking code performance
library(dplyr)
library(stringr)
library(janitor)
library(DT)

source("C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\R\\plot_helpers.R")
source("C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\R\\audio_meta.R")
source("C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\R\\server_helpers.R")

#change max supported audio file size to 30MB
options(shiny.maxRequestSize = 30 * 1024 ^ 2)

bto_df <- read.csv("C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\R\\bto_codes.csv", fileEncoding = "UTF-8-BOM")

ldir   <- "C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\R\\labels\\" #label directory
#################################maybe needed
empty_lab_df <- read.csv(paste0(ldir, "labels_tmp.csv"))[FALSE, ]

species_list <- read.csv("C:\\Users\\ElementXX\\Desktop\\RSTudioNshinYXX888\\FrontEnd999XX\\MRWFrontE999XX\\BirdNETmonitor\\R\\species_list.csv", fileEncoding = "UTF-8-BOM", check.names = FALSE)
#Some taken from https://www.audubon.org/news/a-beginners-guide-common-bird-sounds-and-what-they-mean
call_types <- c("song", "call", "subsong", "alarm call", "begging call", "contact call", "flight call",
                "flock", "juvenile call", "mimicry", "nocturnal call", "whisper song")
misc_categories <- c("Human", "Bird - Cannot Identify", "Anthropogenic Noise", "Weather Noise",
                     "Insect Noise", "Other Noise")
playback_vals <- c(0.1, 0.25, 0.5, 1, 2, 5, 10)
names(playback_vals) <- paste0(playback_vals, "x")

hotkeys <- c(
  "shift+space",
  "shift+enter",
  "shift+backspace",
  "shift+left",
  "shift+right",
  "shift+n", "shift+w",
  paste(1:9)
)

.is_null <- function(x) return(is.null(x) | x %in% c("", "<NULL>"))

btn_row_style  <- "display: inline-block;
                   width: 100%;
                   height: 100%;
                   text-align: center;
                   vertical-align: center;
                   horizontal-align: center;"
btn_sel_style  <- "display:inline-block;
                   text-align: left;
                   padding-left: 1%;
                   width: 100%;"
file_btn_style <- "padding:1%; width:100%;"
header_btn_style <- "padding: 0%;
                     vertical-align: center;"
plot_z_style <- "
#specplot_freq {
  position: absolute;
  z-index: 1;
}
#specplot_time {
  position: absolute;
  z-index: 2;
}
#specplot_front {
  position: absolute;
  z-index: 3;
}"

jsCode <- "shinyjs.audiotoggle = function() {
  var audio = document.getElementById('my_audio_player');
  if (audio.paused){ //check audio is playing
    audio.play();
  } else {
    audio.pause();
  }
}"

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
    waiter::useWaiter(),
    waiter::waiterShowOnLoad(html = waiter::spin_inner_circles(), color = '#999999'),
    dashboardPage(
      title = "Hawaii Monitoring",
      dark = NULL,
      dashboardHeader(
        title = dashboardBrand("Hawaii Monitoring", image = "www/logo-birdnet_icon.png"),
        compact = TRUE,
        rightUi =  mod_sign_out_ui("sign_out_1"),
        div(
          mod_global_filter_ui("global_filter_1"),
          style = "margin-right: 12px"
        ),
        div(
          mod_get_data_daterange_ui("get_data_daterange_1"),
          style = "margin-bottom: -17px; margin-right: 12px"
        ),
        div(
          mod_set_timezone_ui("set_timezone_1"),
          style = "margin-bottom: -17px; margin-right: 12px"
        )
      ),
      dashboardSidebar(
        sidebarMenu(
          menuItem("Overview", tabName = "overview", icon = icon("home")),
          menuItem("Detections", tabName = "detections", icon = icon("music")),
          menuItem("Health", tabName = "health", icon = icon("wave-square")),
          menuItem("Annotation Tool", tabName = "anno", icon = icon("music"))
        )
      ),
      dashboardBody(
        tabItems(
          tabItem(
            tabName = "overview",
            mod_status_overview_ui("status_overview_1"),
          ),
          tabItem(
            tabName = "detections",
            mod_detections_table_ui("detections_table_1")

          ),
          tabItem(
            tabName = "health",
            mod_health_ui("health_1")
          ),

          tabItem(
            tabName = "anno",
            header <- {
              dashboardHeader(
                title = div(img(src = "ne-logo.jpg", height = 30), "Audio Labeller"),
                titleWidth = 300,
                dropdownMenu(
                  tags$li(class = "dropdown",
                          uiOutput("start_ui")
                  ),
                  tags$li(class = "dropdown",
                          auth0::logoutButton()
                  ),
                  type = "notifications",
                  icon = icon("user"),
                  badgeStatus = NULL,
                  headerText  = uiOutput("user_ui")
                ),
                dropdownMenu(tags$li(class = "dropdown",
                                     HTML("<kbd>&#8679;</kbd>+<kbd>&#9166;</kbd> to Save Selection <br/>"),
                                     HTML("<kbd>&#8679;</kbd>+<kbd>&#9003;</kbd> to Delete Selection <br/>"),
                                     HTML("<kbd>&#8679;</kbd>+<kbd>&#8592;</kbd> to move to previous file <br/>"),
                                     HTML("<kbd>&#8679;</kbd>+<kbd>&#8594;</kbd> to move to next file <br/>"),
                                     HTML("<kbd>&#8679;</kbd>+<kbd>Space</kbd> to pause/play audio<br/>"),
                                     HTML("<kbd>&#9166;</kbd> in additional category textbox to add one"),
                                     HTML("<kbd>&#9003;</kbd> in category list to delete one")
                ),
                type = "notifications",
                icon = icon("keyboard"),
                badgeStatus = NULL,
                headerText  = "Hotkeys"
                ),
                dropdownMenu(
                  type = "notifications",
                  icon = icon("question-circle"),
                  badgeStatus = NULL,
                  headerText  = "Links:",
                  tags$li(
                    a(href = "https://github.com/gibbona1/neal",
                      target = "_blank",
                      tagAppendAttributes(icon("github"), class = "text-info"),
                      "GitHub")
                  ),
                  tags$li(
                    a(href = "https://github.com/gibbona1/neal/tree/master/instruction_doc",
                      target = "_blank",
                      tagAppendAttributes(icon("file"), class = "text-info"),
                      "Instructions")
                  ),
                  tags$li(
                    a(href = "https://www.bto.org/sites/default/files/u16/downloads/forms_instructions/bto_bird_species_codes.pdf",
                      target = "_blank",
                      tagAppendAttributes(icon("crow"), class = "text-info"),
                      "BTO Species Codes")
                  ),
                  tags$li(
                    a(href = "https://www.marei.ie/project/natureenergy/",
                      target = "_blank",
                      tagAppendAttributes(icon("bookmark"), class = "text-info"),
                      "Nature+Energy homepage")
                  )
                )
              )
            }


            ###DOWNLOAD SELECTED DATA
            #selectInput("selected", "Download Audio:",

            #           choices = c("species")), #audio", "sound_url", "Species"

            # Button
            #downloadButton("downloadData", "Download selected Audio"), #downloadData: ref zu function
            #mainPanel(tableOutput("sound_1")),####CHANGE from table
            #mod_sound_ui("sound_1")
          )
        )#end tabItem
      )#end DashboardPage
    )#endTagList
  )
}

sidebar <- {
  dashboardSidebar(
    tags$head(tags$style(HTML(".sidebar-menu > li {white-space: normal;}"))),
    shinyjs::useShinyjs(),
    sidebarMenu(
      menuItem("Configuration", tabName = "config_menu", icon = icon("bars"),
               #File/Folder selection
               shinyDirButton("folder",
                              label = "Folder select",
                              title = "Please select a folder",
                              icon  = icon("folder")),
               h5("Data folder"),
               verbatimTextOutput("folder", placeholder = TRUE),
               fileInput("upload_files", "Upload files to Data folder", multiple = TRUE, accept = "audio/wav"),
               selectInput("mode", "Label Mode",
                           choices = c("Bats" = "bats", "Birds (default)" = "birds"),
                           selected = "birds"),
               selectInput("species_list",
                           "Species List:",
                           choices = colnames(species_list),
                           width   = "100%"),
               checkboxInput("bto_codes", "Display as BTO codes", value = FALSE),
               actionButton("inputLoad", "Load Settings")
      ),
      menuItem("Sound Settings", tabName = "sound_menu", icon = icon("music"),
               sliderInput(
                 "db_gain",
                 "dB Gain:",
                 min   = -96,
                 max   = 96,
                 value = -20,
                 ticks = FALSE
               ),
               numericInput("t_step", "Audio length (in window)",
                            value = 15, min = 10, max = 60, step = 1)
      ),
      menuItem("Spectrogram Settings",
               tabName = "spec_menu",
               icon    = icon("chart-area"),
               sliderInput("spec_height",
                           "Plot Height",
                           min   = 300,
                           max   = 800,
                           value = 300,
                           ticks = FALSE,
                           step  = 100),
               sliderInput("spec_samp", "Spectrogram Sampling proportion",
                           min = 0.1, max = 1, value = 1, step = 0.05),
               selectInput("spec_interpolate", "Plot Interpolation",
                           choices = c("Yes" = TRUE, "No" = FALSE)),
               selectInput("freq_min", "minimum frequency in filter",
                           choices = c(0, 2^(3:7)), selected = 0),
               selectInput("freq_max", "maximum frequency in filter",
                           choices = 2^(4:9), selected = 32),
               selectInput(
                 "noisereduction",
                 "Noise reduction:",
                 choices  = c("None", "Rows", "Columns"),
                 selected = "None",
                 width    = "100%"
               ),
               selectInput(
                 "spec_db",
                 "dB type",
                 choices = c("max0", "A", "B", "C", "D"),
                 selected = "max0",
                 width = "100%"
               ),
               selectInput(
                 "palette_selected",
                 "Spectrogram colour palette:",
                 choices = palette_list,
                 width   = "100%"
               ),
               sliderInput(
                 "db_contrast",
                 "Contrast:",
                 min   = 0,
                 max   = 96,
                 value = 0,
                 ticks = FALSE
               ),
               checkboxInput("palette_invert", "Invert color palette"),
               actionButton("savespec", "Download Spectrogram", icon = icon("save")),
               checkboxInput("include_hover", "Include spectrogram hover tooltip",
                             value = FALSE),
               checkboxInput("spec_time_js", "JS vertical line guide", value = FALSE),
               checkboxInput("spec_time", "Vertical line guide for audio current time",
                             value = FALSE),
               checkboxInput("spec_freq_bounds", "Show grey boxes over filtered out audio", value = TRUE),
               checkboxInput("include_guides", "Selected time/frequency guidelines",
                             value = FALSE),
               checkboxInput("spec_labs", "Show spectrogram labels", value = TRUE),
               downloadButton("downloadSpec", "Download Spec as CSV"),
               checkboxInput("clean_zero", "Zero Audio outside Selected", value = TRUE),
               checkboxInput("base_specplot", "Base spectrogram plot", value = FALSE),
               uiOutput("spec_collapse")
      ),
      menuItem("FFT Settings", tabName = "fft_menu", icon = icon("barcode"),
               numericInput("window_width", "Window Size (number of points)",
                            value = 256),
               numericInput("fft_overlap", "FFT Overlap (%)",
                            value = 75, min = 0, max = 99, step = 1),
               numericInput("window_width_disp", "Window Size for display spectrogram",
                            value = 1024),
               numericInput("fft_overlap_disp", "FFT Overlap for display spectrogram (%)",
                            value = 15, min = 0, max = 99, step = 1)
      ),
      #menuItem("Oscillogram Settings",
      #         tabName = "osc_menu", icon = icon("chart-line"),
      #         actionButton("saveosc", "Download Oscillogram", icon = icon("save")),
      #         checkboxInput("include_hover_osc", "Include oscillogram hover tooltip",
      #                       value = FALSE),
      #         checkboxInput("osc_labs", "Show oscillogram labels"),
      #         checkboxInput("include_osc", "Show Oscillogram", value = FALSE),
      #         uiOutput("osc_collapse")
      #),
      #menuItem("Data Settings", tabName = "data_menu", icon = icon("database"),
      #         #checkboxInput("hide_other_labels", "Hide other users' labels", value = TRUE),
      #         #downloadButton("downloadData", "Download Labels")
      #),
      menuItem("Other Settings", tabName = "other_menu", icon = icon("cog"),
               selectInput("label_display", "Label display type", c("grid", "flex")),
               numericInput("label_columns", "Number of Columns",
                            value = 7, min = 1, max = 15, step = 1),
               actionButton("reset_sidebar", "Reset Sidebar"),
               actionButton("reset_body", "Reset Body"),
               checkboxInput("fileEditTab", "Label Edit Table", value = FALSE),
               checkboxInput("fileSummaryTab", "File Summary Table", value = FALSE),
               checkboxInput("summaryTabGroup", "Subgroup by class", value = FALSE),
               checkboxInput("summaryTabNozero", "Remove zero counts", value = FALSE)
               # Add the Undo/Redo buttons to the UI
               #h5("Undo/Redo label save or delete"),
               #undoHistoryUI("lab_hist", back_text = "Undo", fwd_text = "Redo")#,
               #undoHistoryUI_debug("lab_hist")
      )
    ),
    #Options for sidebar
    collapsed = TRUE,
    minified  = FALSE,
    id = "side-panel")
}

body <- {
  dashboardBody(
    shinyjs::useShinyjs(),
    extendShinyjs(text = jsCode, functions = c("audiotoggle")),
    useKeys(),
    uiOutput("loadScript"),
    keysInput("keys", hotkeys),
    id    = "main-panel",
    theme = "blue_gradient",
    tags$style(".content-wrapper{margin-left: 0px;}"),
    tags$head(tags$style(HTML(".content {padding-top: 0;}"))),
    fluidRow({
      div(
        column(1,
               HTML("<b>Filename: </b>")
        ),
        column(7,
               selectInput(
                 "file1",
                 label   = NULL,
                 choices = c(""),
                 width   = "100%"
               ),
               tags$head(tags$style(HTML("
                            #file1+ div>.selectize-input{
                            font-size: 14px; line-height: 14x; margin-bottom: -20px;
                            min-height: 0px;
                            }
                            #file1+ div>.selectize-dropdown{
                            font-size: 14px; margin-top: 20px;
                            }
                            ")))
        ),
        column(2,
               HTML("File Change"),
               fluidRow(
                 column(6, style = "padding:0px;",
                        tipify(
                          actionButton("prev_file", "",
                                       icon  = icon("arrow-left"),
                                       style = file_btn_style),
                          "Previous File"
                        ),
                 ),
                 column(6, style = "padding:0px;",
                        tipify(actionButton("next_file", "",
                                            icon  = icon("arrow-right"),
                                            style = file_btn_style),
                               "Next File")
                 )
               )
        ),
        column(2,
               fluidRow(
                 uiOutput("segmentNumText"),
                 column(6, style = "padding:0px;",
                        tipify(
                          actionButton("prev_section", "",
                                       icon  = icon("chevron-left"),
                                       style = file_btn_style),
                          "previous section"
                        )
                 ),
                 column(6, style = "padding:0px;",
                        tipify(
                          actionButton("next_section", "",
                                       icon  = icon("chevron-right"),
                                       style = file_btn_style),
                          "next section"
                        )
                 )
               )
        )
      )
    }),
    #Spectrogram Plot
    fluidRow({
      uiOutput("specplot_ui")
    }),
    #Oscillogram Plot
    #fluidRow({
    #  uiOutput("oscplot_ui")
    #  }),
    #One row of audio settings
    fluidRow({
      div(
        column(4, style = "padding:0px;",
               #br(),
               actionButton("save_points",
                            HTML("<b>Save Selection</b>"),
                            icon  = icon("vector-square"),
                            style = "width: 100%; background-color: #fff491;"),
               uiOutput("meta_text")
        ),
        column(3, {
          div(
            uiOutput("audio_title"),
            uiOutput("my_audio"),
            tags$script(src = "JS/audio_time.js")
            #actionButton("get_time", "Get Time", onclick = js),
            #verbatimTextOutput("audio_time")
          )
        }),
        column(3, {
          fixedRow(style = btn_row_style,
                   div(
                     column(5,
                            uiOutput("downloadAudio_ui")
                     ),
                     column(7,
                            selectInput(
                              "playbackrate",
                              "Playback Speed:",
                              choices  = playback_vals,
                              selected = 1,
                              width    = "100%"
                            )
                     )))
        }),
        column(2, {
          fixedRow(style = btn_row_style,
                   fluidRow(style = btn_row_style,
                            actionButton("plt_reset", "Reset Zoom",
                                         style = file_btn_style)
                   )
          )
        })
      )
    }),
    #Label Buttons UI
    fluidRow({
      div(style = btn_sel_style,
          uiOutput("label_ui"), #backspace to delete
          tags$script(src = "JS/remove_category.js"),
          column(6,
                 textInput("otherCategory", "Type in additional category:",
                           width = "100%"), #enter to add category
                 tags$script(src = "JS/add_category.js"),
                 div(HTML("<b>Category buttons</b>"),
                     div(style = "width: 100%; display: inline-block;",
                         tipify(actionButton("addCategory",
                                             HTML("<b>Add</b>"),
                                             icon  = icon("plus-square"),
                                             style = "width: 24%; text-align:left;"), "Add category"),
                         tipify(actionButton("remCategory",
                                             HTML("<b>Remove</b>"),
                                             icon  = icon("minus-square"),
                                             style = "width: 24%; text-align:left;"), "Remove selected category"),
                         tipify(actionButton("resetCategory",
                                             HTML("<b>Reset</b>"),
                                             icon  = icon("list"),
                                             style = "width: 24%; text-align:left;"), "Remove custom categories added"),
                         disabled(tipify(actionButton("save_extra",
                                                      HTML("<b>Save to List</b>"),
                                                      icon  = icon("archive"),
                                                      style = "width: 24%; text-align:left;"), "Save custom labels to its own file/column of species list"))
                     )
                 ),
                 #Label buttons
                 div(HTML("<b>Label buttons</b>"),
                     div(style="width: 100%; display: inline-block;",
                         tipify(actionButton("remove_points",
                                             HTML("<b>Delete</b>"),
                                             icon  = icon("trash-alt"),
                                             style = "width: 24%; text-align:left"), "Delete selection"),
                         tipify(actionButton("reset_labels",
                                             HTML("<b>Clear</b>"),
                                             icon  = icon("eraser"),
                                             style = "width: 24%; text-align:left;"), "Clear all labels for this file"),
                         #tipify(actionButton("undo_delete_lab",
                         #             HTML("<b>Undo</b>"),
                         #             icon  = icon("undo-alt"),
                         #             style = "width: 24%; text-align:left;"), "Undo last deleted label(s)"),
                         tipify(downloadButton("downloadData", "Download", style = "width: 24%; text-align:left;"), "Download labels for all files"))
                 )
          ),
          #TODO: Other info to label/record -
          ## altitude of recorder (check if in metadata)
          column(6,
                 #div(#style = btn_sel_style,
                 tags$style("#call_type {padding: 0%;}"),
                 selectInput(
                   inputId    = "call_type",
                   label      = "Call Type:",
                   width      = "100%",
                   multiple   = TRUE,
                   choices    = call_types,
                   selected   = NULL#)
                 ),
                 #notes, frequency filtering and label confidence
                 HTML("<b>Additional Notes:</b>"),
                 textAreaInput("notes", NULL, width = "100%", resize = "vertical")
          )
      )
    }),
    fluidRow({
      div(
        column(6,
               uiOutput("freq_ui")
        ),
        column(6,
               sliderInput("label_confidence", "Label Confidence:",
                           min   = 0,
                           max   = 1,
                           step  = 0.05,
                           value = 1,
                           ticks = FALSE,
                           width = "100%"),
               div(div(style = "float:left;", "low"),
                   div(style = "float:right;", "high"))
        )
      )
    }),
    #label summary and edit
    fluidRow({
      uiOutput("fileLabInfo")
    }),
    #file summary
    fluidRow({
      uiOutput("fileLabSummary")
    })
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

