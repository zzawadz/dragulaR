library(shinydashboard)
library(dragulaR)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody(
    box(width = 12, verbatimTextOutput("text")),
    box(width = 6, id = "drag1", title = "Drag1",
      div(drag = "iris", box(width = 12,  plotOutput("iris"))),
      div(drag = "mtcars", box(width = 12, plotOutput("mtcars"))),
      div(drag = "AirPassengers", box(width = 12, plotOutput("AirPassengers"))),
      div(drag = "Formaldehyde", box(width = 12, plotOutput("Formaldehyde")))
    ),
    box(width = 6, id = "drag2", title = "Drag2",
        div(drag = "USArrests", box(width = 12, plotOutput("USArrests")))),

    dragulaOutput("Dragula")
  )
)
# Define server logic required to draw a histogram
server <- function(input, output) {

  output$Dragula <- renderDragula({
    dragula(c("drag1", "drag2"))
  })

  output$text <- renderPrint({
    dragulaValue(input$Dragula)
  })

  output$iris = renderPlot({plot(iris)})
  output$mtcars = renderPlot({plot(mtcars)})
  output$AirPassengers = renderPlot({plot(AirPassengers)})
  output$Formaldehyde = renderPlot({plot(Formaldehyde)})
  output$USArrests = renderPlot({plot(USArrests)})
}

# Run the application
shinyApp(ui = ui, server = server)

