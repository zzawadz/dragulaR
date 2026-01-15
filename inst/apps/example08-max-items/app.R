library(shiny)
library(dragulaR)

# Example demonstrating maxItems option to limit items in drop zones
# This addresses GitHub Issue #4: https://github.com/zzawadz/dragulaR/issues/4

makeElement <- function(data, name) {
  div(
    style = "border-width:2px;border-style:solid;margin:5px;padding:10px;background-color:#f5f5f5;",
    drag = name,
    div(class = "active title", name),
    div(class = "active content", p(sprintf("Class: %s", class(data[[name]]))))
  )
}

ui <- fluidPage(
  titlePanel("Limit Maximum Items with dragulaR (Issue #4)"),

  helpText("The 'Model' container is limited to a maximum of 3 items.
           Try dragging more than 3 items - additional items will be rejected."),

  fluidRow(
    style = "margin: 15px;",
    column(
      3,
      h3("Available Variables:"),
      div(
        id = "Available",
        style = "min-height: 600px; background-color: #e8e8e8; padding: 10px;",
        lapply(colnames(mtcars), makeElement, data = mtcars)
      )
    ),
    column(
      3,
      h3("Model (max 3 items):"),
      div(
        id = "Model",
        style = "min-height: 600px; background-color: #d4edda; padding: 10px; border: 2px dashed #28a745;"
      )
    ),
    column(
      6,
      h4("Current State:"),
      verbatimTextOutput("state"),
      h4("Plot:"),
      plotOutput("plot")
    )
  ),
  dragulaOutput("dragula")
)

server <- function(input, output) {

  output$dragula <- renderDragula({
    dragula(
      c("Available", "Model"),
      maxItems = list(Model = 3),  # Limit Model container to 3 items
      removeOnSpill = FALSE
    )
  })

  output$state <- renderPrint({
    req(input$dragula)
    state <- dragulaValue(input$dragula)
    cat("Available variables:", length(state$Available), "\n")
    cat("  ", paste(state$Available, collapse = ", "), "\n\n")
    cat("Model variables:", length(state$Model), "/ 3 max\n")
    cat("  ", paste(state$Model, collapse = ", "), "\n")
  })

  output$plot <- renderPlot({
    req(input$dragula)
    state <- dragulaValue(input$dragula)
    validate(
      need(
        length(state$Model) >= 2,
        message = "Please select at least 2 variables for the model."
      )
    )
    plot(mtcars[, state$Model], main = "Selected Variables")
  })

}

shinyApp(ui = ui, server = server)
