#' detections_table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import reactable
#' @import httr2
#' @import dplyr
mod_detections_table_ui <- function(id) {
  ns <- NS(id)
  tagList(
    reactableOutput(ns("table")),
    actionButton(ns("Correct"), "correct"),
    actionButton(ns("Incorrect"), "incorrect"),
    actionButton(ns("SetToBanana"), "set_to_banana")
  )
}

#' detections_table Server Functions
#'
#' @param id Internal parameter for {shiny}
#' @param detections reactive
#'
#' @noRd
mod_detections_table_server <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    table_dats <- reactive({
      req(data$detections)
      data$detections %>%
        mutate(
          datetime = strftime(datetime, "%F %T", tz = lubridate::tz(datetime)),
          verification = row_number()  # Add a unique row ID
        ) %>%
        dplyr::relocate(common, .after = recorder_id)
    })

    output$table <- renderReactable({
      reactable(
        table_dats(),
        defaultSorted = list(datetime = "desc"),
        filterable = TRUE,
        resizable = TRUE,
        highlight = TRUE,
        selection = "single",
        outlined = TRUE,
        compact = TRUE,
        elementId = "detections-list",
        columns = list(
          uid = colDef(show = FALSE),
          recorder_id = colDef(
            name = "Recorder ID",
            filterInput = dataListFilter("detections-list")
          ),
          datetime = colDef(
            name = "Datetime"
          ),
          start = colDef(show = FALSE),
          end = colDef(show = FALSE),
          common = colDef(
            name = "Species",
            filterInput = dataListFilter("detections-list")
          ),
          scientific = colDef(show = FALSE),
          species_code = colDef(show = FALSE),
          snippet_path = colDef(
            name = "audio",
            html = TRUE,
            cell = function(value) {
              if (value == "None") {
                '<i class="fa-solid fa-music", style = "color:#eaecee "></i>'
              } else {
                '<i class="fa-solid fa-music", style = "color:#008080"></i>'
              }
            }
          ),
          lat = colDef(show = FALSE),
          lon = colDef(show = FALSE),
          confirmed = colDef(show = FALSE),
          confidence = colDef(
            filterable = TRUE,
            filterMethod = JS("function(rows, columnId, filterValue) {
                return rows.filter(function(row) {
                  return row.values[columnId] >= filterValue
                })
              }")
          ),
          verification = colDef(
            name = "Verification",
            html = TRUE,

          )
        )
      )
    })

    observeEvent(input$Correct, {
      verification_data <- table_dats()
      selected_row <- input$table_rows_selected
      if (!is.null(selected_row)) {
        verification_data$verification[selected_row] <- selected_row + 1  # Set the value to row number
        updateReactable(session, "detections-list", verification_data)
      }
    })

    observeEvent(input$Incorrect, {
      verification_data <- table_dats()
      selected_row <- input$table_rows_selected
      if (!is.null(selected_row)) {
        verification_data$verification[selected_row] <- selected_row + 1  # Set the value to row number
        updateReactable(session, "detections-list", verification_data)
      }
    })

    observeEvent(input$SetToBanana, {
      verification_data <- table_dats()
      selected_row <- input$table_rows_selected
      if (!is.null(selected_row)) {
        verification_data$verification[selected_row] <- selected_row + 1  # Set the value to row number
        updateReactable(session, "detections-list", verification_data)
      }
    })

    # JavaScript functions...
    session$onFlushed(function() {
      session$sendCustomMessage("shinyjs-extend",
                                list(
                                  code = '
        $(document).on("click", ".verify-button", function() {
          var rowIndex = parseInt($(this).data("reactable-row"));
          var isCorrect = confirm("Is this detection correct?");
          verifyRow(rowIndex, isCorrect);
        });

        $(document).on("shiny:connected", function() {
          // Set button styles on initial load
          $(".verify-button").addClass("neutral-button");
        });

        function verifyRow(index, isCorrect) {
          var table = document.getElementById("detections-list");
          var rowData = table.reactable.sortedData[index];
          var xxx = rowData.xxx;

          // Send verification status to server using Shiny
          Shiny.setInputValue("verify_detection", { xxx: xxx, isCorrect: isCorrect });
        }

        Shiny.addCustomMessageHandler("update_button_style", function(data) {
          var rowIndex = data.index;
          var isCorrect = data.isCorrect;
          var button = $(".verify-button").filter(function() {
            return $(this).data("reactable-row") == rowIndex.toString();
          });
          button.removeClass("neutral-button");
          button.removeClass("correct-button");
          button.removeClass("incorrect-button");
          if (isCorrect) {
            button.addClass("correct-button");
          } else {
            button.addClass("incorrect-button");
          }
        });
      '
                                )
      );
    })
  })
}

## To be copied in the UI
# mod_detections_table_ui("detections_table_1")

## To be copied in the server
# mod_detections_table_server("detections_table_1")
