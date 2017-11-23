library(shiny)

makeElement <- function(data, name)
{
  div(style = "border-width:2px;border-style:solid;",
    drag = name,
    div(class = "active title", name),
    div(class = "active content", p(sprintf("Class: %s", class(data[[name]])))))
}

ui <- fluidPage(
  titlePanel("Drag and drop elements with dragulaR"),

  fluidRow(style = "margin: 15px;",
    column(3,
      h3("Drag from here:"),
      div(id = "Available", style = "min-height: 600px;",
        lapply(colnames(mtcars), makeElement, data = mtcars))
    ),
    column(3,
      h3("Drop here:"),
      div(id = "Model", style = "min-height: 600px;")
    ),
    column(6,
      plotOutput("plot"),
      verbatimTextOutput("print")
    )
  ),
  dragulaOutput("dragula")

)

server <- function(input, output) {

  output$dragula <- renderDragula({
    dragula(c("Available", "Model"))
  })

  output$plot <- renderPlot({
    req(input$dragula)
    state <- dragulaValue(input$dragula)
    validate(need(length(state$Model) > 1, message = "Please select at least two variables."))

    plot(mtcars[,state$Model])
  })

  output$print <- renderText({
    state <- dragulaValue(input$dragula)
    sprintf("Available:\n  %s\n\nModel:\n  %s",
            paste(state$Available, collapse = ", "),
            paste(state$Model, collapse = ", "))

  })

}

shinyApp(ui = ui, server = server)
