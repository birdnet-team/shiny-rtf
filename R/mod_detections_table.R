library(shiny)
library(shinyWidgets)
library(leaflet)
library(reactable)
library(dplyr)
library(lubridate)
library(av)
library(reactable)

# detections_table UI-Funktion
mod_detections_table_ui <- function(id) {
  ns <- NS(id)




  tagList(
    # uiOutput("ja"), HTML("<br/>"),
    # uiOutput("nein"), HTML("<br/>"),
    # uiOutput("vllt"),
    actionButton(inputId = ns("ja"), label = "Ja", icon = icon("check")),
    actionButton(inputId = ns("nein"), label = "Nein", icon = icon("check")),
    actionButton(inputId = ns("confirm_button"), label = "Confirm", icon = icon("check")),
    fluidRow(
      column(
        7,
        shinyWidgets::panel(
          extra = reactableOutput(ns("table")),
          heading = "Detections"
        )
      ),
      column(
        5,
        leafletOutput(ns("map")),
        conditionalPanel(
          ns = ns,
          condition = "!output.show_spec_panel",
          shinyWidgets::panel(
            heading = "Spectrogram",
            div(
              p("No media selected or available"),
              style = "margin-top: 5rem; margin-bottom: 5rem; text-align: center; font-size: larger;color: #b1b1b1;"
            )
          )
        ),
        conditionalPanel(
          ns = ns,
          condition = "output.show_spec_panel",
          shinyWidgets::panel(
            heading = "Spectrogram",
            fluidRow(plotOutput(ns("spectrogram"))),
            fluidRow(uiOutput(ns("audio_controls"))),
            fluidRow(
              column(
                4,
                sliderInput(
                  ns("max_freq"),
                  label = "max. frequency (kHz)",
                  ticks = FALSE,
                  value = 24,
                  max = 24,
                  min = 1,
                  step = 0.5
                )
              ),
              column(
                4,
                selectInput(
                  inputId = ns("fft_window_length"),
                  label = "window length (FFT)",
                  choices = c("512", "1024", "2048"),
                  multiple = FALSE,
                  selectize = TRUE,
                  selected = "1024"
                )
              ),
              column(
                4,
                sliderInput(
                  ns("fft_overlap"),
                  label = "overlap (FFT)",
                  ticks = FALSE,
                  value = 0.75,
                  min = 0.60,
                  max = 0.98,
                  step = 0.01
                )
              )
            )
          )
        )
      )
    )
  )
}

mod_detections_table_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$ja <- renderUI({
      actionButton(
        "ja",
        label = "Ja"
      )
    })

    table_selected <- reactive(getReactableState("detections-list", "selected"))

    # observeEvent(input$ja, {
    #   df <- table_dats()
    #   ind <- table_selected()
    #   df[ind, "confirmed"] <- TRUE
    #   updateReactable("detections-list", data = df)
    #   print("tabelle aktualisiert")
    # })

    # observeEvent(input$ja, {
    #   df <- table_dats()
    #   ind <- table_selected()
    #   if (is.null(ind)) {
    #     df[ind, "confirmed"] <- TRUE
    #     updateReactable("detections-list", data = df)
    #     print("Tabelle aktualisiert und validiert")
    #   }
    # })

    # observeEvent(input$ja, {
    #   selected_row_index <- reactable::getReactableState("detections-list", "selected", session)
    #   if (is.null(selected_row_index)) {
    #     df <- table_dats()
    #     df$confirmed[selected_row_index] <- "ja"
    #     updateReactable("detections-list", data = df)
    #     print(table_selected)
    #     print("Wert von confirmed auf 'Ja' gesetzt")
    #   }

#XX#       observeEvent(input$ja, {
#         selected_row_index <- reactable::getReactableState("detections-list", "selected", session)
#         if (is.null(selected_row_index)) {
#           df <- table_dats()
#           df$confirmed[selected_row_index] <- TRUE
#           updateReactable("detections-list", data = df)
#           print("Wert von confirmed auf 'Ja' gesetzt")
#         }
# })

    # observeEvent(input$ja, {
    #   selected_row_index <- reactable::getReactableState("detections-list", "selected", session)
    #   if (!is.null(selected_row_index)) {
    #     df <- table_dats()
    #     df$confirmed[selected_row_index] <- TRUE
    #     updateReactable("detections-list", data = df)
    #     print("Wert von confirmed auf 'Ja' gesetzt")
    #   }
    # })

    # observeEvent(input$ja, {
    #   selected_row_index <- reactable::getReactableState("detections-list", "selected", session)
    #   if (!is.null(selected_row_index)) {
    #     df <- table_dats()
    #     df$confirmed[selected_row_index] <- TRUE
    #     print("Vor dem Aktualisieren:")
    #     print(df)  # Überprüfen Sie den Zustand des DataFrames
    #     updateReactable("detections-list", data = df)
    #     print("Nach dem Aktualisieren:")
    #     print(table_dats())  # Überprüfen Sie den Zustand der reaktiven Daten
    #     print("Wert von confirmed auf 'Ja' gesetzt")
    #   }
    # })


      # if (is.null(selected_row_index)) { #which value backend????
      #   df <- table_dats()
      #   #df$confirmed[selected_row_index] == "Nein"
      #   df$confirmed[selected_row_index] <- TRUE
      #   print("kills it")
      #   updateReactable("detections-list", data = df)
      #   #table_dats(data.frame(detections = df))
      #   print("Wert von confirmed auf 'Ja' gesetzt")
      # }
    #})

    # observeEvent(input$ja, {
    #   df <- table_dats()  # Holen Sie die Daten aus der reaktiven Liste
    #   ind <- table_selected()
    #   df[ind, "confirmed"] <- TRUE
    #   table_dats() <- df  # Aktualisieren Sie die reaktive Liste
    #   # updateReactable("detections-list", data = df)  # Diese Zeile ist nicht mehr notwendig
    # })


    # observeEvent(input$ja, {
    #   selected_row_index <- reactable::getReactableState("detections-list", "selected", session)
    #   if (!is.null(selected_row_index)) {
    #     df <- table_dats()
    #     print("why")
    #     if (df$confirmed[selected_row_index] == "Nein" ) {
    #       print("its no")
    #       df$confirmed[selected_row_index] <- "Ja"
    #       updateReactable("detections-list", data = df)
    #       print("Wert von confirmed auf 'Ja' gesetzt")
    #     }
    #   }
    # })

    output$nein <- renderUI({
      actionButton(
        "nein",
        label = "Nein"
      )
    })

    observeEvent(input$nein, {
      df <- table_dats()
      ind <- table_selected()
      df[ind, "confirmed"] <- FALSE
      updateReactable("detections-list", data = df)
    })

    output$vllt <- renderUI({
      actionButton(
        "vllt",
        label = "Vielleicht"
      )
    })

    observeEvent(input$vllt, {
      df <- table_dats()
      ind <- table_selected()
      df[ind, "confirmed"] <- NA
      updateReactable("detections-list", data = df)
    })

    output$map <- renderLeaflet({
      req(data$detections)
      leaflet() %>%
        addTiles(group = "OpenStreetMap") %>%
        addProviderTiles("Esri.WorldImagery", group = "Satellit") %>%
        addMarkers(data = data$detections, lat = ~lat, lng = ~lon,
                   popup = ~paste("Species: ", common, "<br>Time: ", datetime))
    })

    # detection data to be displayed in table
    table_dats <- reactive({
      req(data$detections)
      data$detections %>%
        mutate(datetime_precise = datetime + seconds(start), ) %>%
        mutate(
          datetime_precise = strftime(datetime_precise, "%F %T", tz = lubridate::tz(datetime)),
          sound_play = paste0(
            "https://reco.birdnet.tucmi.de/reco/det/",
            uid,
            "/audio"
          )
        ) %>%
        dplyr::relocate(common, .after = recorder_id)
    })

    # Debounce Input --------------------------------------------------------------------------------------------------
    input_fft_overlap <- reactive({
      input$fft_overlap
    }) |> debounce(200)

    input_max_freq <- reactive({
      input$max_freq
    }) |> debounce(200)

    # URL and FFT data ------------------------------------------------------------------------------------------------
    audio_selected_detection <- reactiveValues(
      url = NULL,
      fft_data = NULL
    )

    # url pointing to the audio file of the detection that is selected in the table
    selected_audio_url <- reactive({
      selected_row_index <- reactable::getReactableState("table", "selected", session)
      table_dats() |>
        slice(selected_row_index) |>
        pull("sound_play")
    })


    # set condition to show spectrogram panel
    output$show_spec_panel <- reactive({
      isTruthy(selected_audio_url())
    })
    outputOptions(output, "show_spec_panel", suspendWhenHidden = FALSE)

    # download audio
    audio_file_path <- reactive({
      req(selected_audio_url())
      destfile <- tempfile(fileext = ".ogg")
      download.file(selected_audio_url(), destfile, mode = "wb")
      destfile
    }) |>
      bindCache(selected_audio_url())

    # load fft data when new detections gets selected
    fft_data <- reactive({
      req(audio_file_path())
      av::read_audio_fft(
        audio_file_path(),
        window = av::hanning(input$fft_window_length),
        overlap = input_fft_overlap()
      )
    })

    # update input$max_freq to half the sample rate
    observe({
      spec_sr <- attr(fft_data(), "sample_rate") / 1000 / 2
      updateNumericInput(
        session = session,
        inputId = "max_freq",
        value = spec_sr,
        max = spec_sr
      )
    }) |> bindEvent(fft_data(), once = TRUE)

    observeEvent(input$table_select, {
      selected_row_index <- input$table_select
      if (!is.null(selected_row_index)) {
        selected_lat <- table_dats()$lat[selected_row_index]
        selected_lon <- table_dats()$lon[selected_row_index]
        leafletProxy("map") %>%
          clearMarkers() %>%
          addMarkers(lat = selected_lat, lng = selected_lon, popup = "Selected Detection")
      }
    })


    # #validation
    #     observeEvent(input$confirm_button, {
    #       selected_row_index <- reactable::getReactableState("detections-list", "selected", session)
    #       if (!is.null(selected_row_index)) {
    #         table_dats()$detections$confirmed[selected_row_index] <- TRUE
    #
    #         # Update the reactive value to trigger the table rendering
    #         table_dats(table_dats())
    #
    #         showNotification("Confirmation updated", type = "message")
    #       }
    #     })
    #
    #
    #
    #     observe({
    #       #browser("recorder_id")
    #       cat("Confirm button clicked\n")
    #       cat("confirm_button value: ", input$confirm_button, "\n")
    #       cat("selected_row_index value: ", input$detections_list_select, "\n")
    #     })

    # render spectrogram
    output$spectrogram <- renderPlot({
      req(fft_data())
      plot_av_fft(fft_data(), kHz = TRUE, max.freq = input_max_freq())
    })

    # render soundbar / audio controls to play the selected file
    output$audio_controls <- renderUI({
      # play directly via url
      div(
        tags$audio(
          src = selected_audio_url(),
          type = "audio/ogg",
          controls = NA
        ),
        style = "margin-top: 10px; margin-bottom: 10px"
      )
      # HTML(paste0('<audio controls><source src="', selected_audio_url(), '" type="audio/wav"></audio>'))
    }) |>
      bindCache(audio_file_path())


    # observe(
    #   table_selected <- function(row_index, selected_rows) {
    #     # Überprüfen, ob die gegebene Zeilennummer in den ausgewählten Zeilen enthalten ist
    #     return(row_index %in% selected_rows)
    #
   # }
    # )

# table_selected <- function(row_index, selected_rows) {
#   return(row_index %in% selected_rows)
# }
   # table_selected <- reactive(getReactableState("detections-list", "selected"))


    # table_selected <- reactive({
    #   selected_row_index <- reactable::getReactableState("detections-list", "selected", session)
    #   return(selected_row_index)
    # })

    output$table <- renderReactable({
      reactable(
        table_dats(),
        defaultSorted = list(datetime_precise = "desc"),
        filterable = TRUE,
        resizable = TRUE,
        highlight = TRUE,
        #outlined = TRUE,
        borderless = TRUE,
        selection = "single",
        onClick = "select",
        elementId = "detections-list",
        showPageSizeOptions = TRUE,
        pageSizeOptions = c(5, 10, 25),
        defaultPageSize = 10,
        theme = reactableTheme(
          rowSelectedStyle = list(backgroundColor = "#eee", boxShadow = "inset 2px 0 0 0 #ffa62d")
        ),
        columns = list(
          .selection = colDef(show = FALSE),
          recorder_id = colDef(
            name = "Recorder ID",
            filterInput = dataListFilter("detections-list")
          ),
          datetime = colDef(show = FALSE),
          datetime_precise = colDef(name = "Datetime"),
          start = colDef(show = FALSE),
          end = colDef(show = FALSE),
          common = colDef(
            name = "Species",
            filterInput = dataListFilter("detections-list")
          ),
          snippet_path = colDef(show = FALSE),
          scientific = colDef(show = FALSE),
          species_code = colDef(show = FALSE),
          snippet_path = colDef(show = FALSE),
          uid = colDef(show = FALSE),
          sound_play = colDef(show = FALSE),
          lat = colDef(show = TRUE),
          lon = colDef(show = TRUE),
          confirmed = colDef(
            show = TRUE,
            cell = JS(
              "function(value, metadata, rowInfo, columnInfo) {
            var row = metadata.row;
            var col = metadata.col;
            var rowSelected = table.getSelectedRows();

            if (selectedRows.includes(row) && document.getElementById('ja').value > 0) {
              return '<span style=\"color: green;\">Ja</span>';
            } else if (value === false) {
              return '<span style=\"color: red;\">Nein</span>';
            } else {
              return value;
            }
          }"
            )
          ),


         #  confirmed = colDef(
         #    #name = confirmed,
         #    show = TRUE,
         #    cell = function(value, metadata) {
         #      ####PROB: Spalte "confirmed" kommt leer aus dem BackEnd an
         #
         #   #if (isTRUE(table_selected)){
         #      if (input$ja) {
         #        tagList(tags$span(style = "color: green;", "Ja"))
         #
         #      } else if (isFALSE(value)) {
         #        tagList(tags$span(style = "color: red;", "Nein"))
         #
         #      }
         #     #}
         #  }
         # ),
          confidence = colDef(
            format = colFormat(digits = 2, locales = "en-US"),
            maxWidth = 150,
            filterable = TRUE,
            filterMethod = JS(
              "function(rows, columnId, filterValue) {
                return rows.filter(function(row) {
                  return row.values[columnId] >= filterValue
                })
              }"
            )
          )
        )
      )
    })
  })
}
