library(shiny)
library(dragulaR)

ui <- fluidPage(
        titlePanel("Drag and drop elements with dragulaR - get order of elements inside enclosing div"),
        fluidRow(id = "plots",
                 column(6, plotOutput("iris"), drag = "iris"),
                 column(6, plotOutput("mtcars"), drag = "mtcars"),
                 column(6, plotOutput("AirPassengers"), drag = "AirPassengers"),
                 column(6, plotOutput("Formaldehyde"), drag = "Formaldehyde")),
        div(id = "tmp"),
        dragulaOutput("dragula"),
        verbatimTextOutput("order")

)

server <- function(input, output) {

  output$dragula <- renderDragula({ dragula("plots") })

  output$order <- renderPrint({
    input$dragula_state
  })

  output$iris = renderPlot({plot(iris)})
  output$mtcars = renderPlot({plot(mtcars)})
  output$AirPassengers = renderPlot({plot(AirPassengers)})
  output$Formaldehyde = renderPlot({plot(Formaldehyde)})

}

shinyApp(ui = ui, server = server)

