library(shiny)
library(dragulaR)

ui <- fluidPage(

        fluidRow(verbatimTextOutput("dragVals")),

        fluidRow(dragulaOutput("drag")),

        fluidRow(id = "plots",
                 column(6, plotOutput("iris")),
                 column(6, plotOutput("mtcars")),
                 column(6, plotOutput("AirPassengers")),
                 column(6, plotOutput("Formaldehyde"))),
        dragula("plots")

)

server <- function(input, output) {

  output$drag = renderDragula({
      tmp = list(colnames(iris), colnames(mtcars))
      dragula(tmp)
    })

  output$dragVals = renderPrint({
    req(input$drag)
    sets = lapply(input$drag, function(x) unlist(x))
    print(sets)
  })

  observeEvent(input$drag, {
    print(input$drag)
    a = input$drag
  })

  output$iris = renderPlot({plot(iris)})
  output$mtcars = renderPlot({plot(mtcars)})
  output$AirPassengers = renderPlot({plot(AirPassengers)})
  output$Formaldehyde = renderPlot({plot(Formaldehyde)})

}

shinyApp(ui = ui, server = server)

