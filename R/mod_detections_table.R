library(shiny)
library(reactable)
library(dplyr)

data <- data.frame(
  id = 1:5, # step 1: ID vergeben #step 2: werte nach n erweitern
  value = c("A", "B", "C", "D", "E"), #step 3: Spalte als Verifikationen, hier = value hinzufügen
  verification = c("false") #standardwert der Spalte
)

ui <- fluidPage(
  titlePanel("Verification Table"),
  reactableOutput("table"),
  actionButton("correctButton", "Correct"),
  actionButton("incorrectButton", "Incorrect"),
  actionButton("setToNAButton", "Set to NA")
)

server <- function(input, output, session) {
  rv <- reactiveValues(df = data)

  output$table <- renderReactable({
    reactable(
      rv$df,
      columns = list(
        id = colDef(name = "ID"),
        value = colDef(name = "Value"),
        verification = colDef(
          name = "Verification",
          html = TRUE
        )
      ),
      defaultSorted = "id",
      selection = "single",
      onClick = "select"
    )
  })

  table_selected <- reactive(getReactableState("table", "selected"))

  observeEvent(input$correctButton, {
    df <- rv$df
    ind <- table_selected()
    df[ind, "verification"] <- "Correct"
    rv$df <- df
    updateReactable("table", data = df)
  })

  observeEvent(input$incorrectButton, {
    df <- rv$df
    ind <- table_selected()
    df[ind, "verification"] <- "Incorrect"
    rv$df <- df
    updateReactable("table", data = df)
  })

  observeEvent(input$setToNAButton, {
    df <- rv$df
    ind <- table_selected()
    df[ind, "verification"] <- "NA"
    rv$df <- df
    updateReactable("table", data = df)
  })
}

shinyApp(ui, server)
