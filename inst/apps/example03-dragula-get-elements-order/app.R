library(shiny)
library(dragulaR)

ui <- fluidPage(
        titlePanel("Get order of elements in div"),
        verbatimTextOutput("order"),
        fluidRow(id = "plots",
                 column(6, plotOutput("iris"), drag = "iris"),
                 column(6, plotOutput("mtcars"), drag = "mtcars"),
                 column(6, plotOutput("AirPassengers"), drag = "AirPassengers"),
                 column(6, plotOutput("Formaldehyde"), drag = "Formaldehyde")),
        dragula("plots", id = "dragula")
)

server <- function(input, output) {


  output$order <- renderPrint({
    dragulaValue(input$dragula)
  })

  output$iris = renderPlot({plot(iris)})
  output$mtcars = renderPlot({plot(mtcars)})
  output$AirPassengers = renderPlot({plot(AirPassengers)})
  output$Formaldehyde = renderPlot({plot(Formaldehyde)})

}

shinyApp(ui = ui, server = server)

