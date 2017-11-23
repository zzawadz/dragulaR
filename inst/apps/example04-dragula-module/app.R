library(shiny)
library(dragulaR)

fooUI <- function(id) {
  ns <- NS(id)
  tagList(
    verbatimTextOutput(ns("order")),
    fluidRow(id = ns("plots"),
             column(6, plotOutput(ns("iris")), drag = "iris"),
             column(6, plotOutput(ns("mtcars")), drag = "mtcars"),
             column(6, plotOutput(ns("AirPassengers")), drag = "AirPassengers"),
             column(6, plotOutput(ns("Formaldehyde")), drag = "Formaldehyde")),
    dragula(ns("plots"), id = ns("dragula"))
  )
}

fooServer <- function(input, output, session) {
  output$order <- renderPrint({
    dragulaValue(input$dragula)
  })

  output$iris = renderPlot({plot(iris)})
  output$mtcars = renderPlot({plot(mtcars)})
  output$AirPassengers = renderPlot({plot(AirPassengers)})
  output$Formaldehyde = renderPlot({plot(Formaldehyde)})
}

ui <- fluidPage(
        titlePanel("Drag and drop elements with dragulaR - inside module"),
        fooUI("foo")
)

server <- function(input, output) {

  callModule(module = fooServer, id = "foo")

}

shinyApp(ui = ui, server = server)

