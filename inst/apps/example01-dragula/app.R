library(shiny)
library(dragulaR)

ui <- fluidPage(
        titlePanel("Drag and drop elements with dragulaR"),
        fluidRow(id = "plots",
                 column(6, plotOutput("iris")),
                 column(6, plotOutput("mtcars")),
                 column(6, plotOutput("AirPassengers")),
                 column(6, plotOutput("Formaldehyde"))),
        dragula("plots")

)

server <- function(input, output) {

  output$iris = renderPlot({plot(iris)})
  output$mtcars = renderPlot({plot(mtcars)})
  output$AirPassengers = renderPlot({plot(AirPassengers)})
  output$Formaldehyde = renderPlot({plot(Formaldehyde)})

}

shinyApp(ui = ui, server = server)

