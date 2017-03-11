library(shinydashboard)
library(dragulaR)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody(
    box(width = 12, verbatimTextOutput("text")),
    box(width = 6, id = "drag1", title = "Drag1",
      box(width = 12, drag = "iris", plotOutput("iris")),
      box(width = 12, drag = "mtcars", plotOutput("mtcars")),
      box(width = 12, drag = "AirPassengers", plotOutput("AirPassengers")),
      box(width = 12, drag = "Formaldehyde", plotOutput("Formaldehyde"))
    ),
    box(width = 6, id = "drag2", title = "Drag2",
        box(width = 12, drag = "USArrests", plotOutput("USArrests"))),

    dragulaOutput("Dragula")
  )
)
# Define server logic required to draw a histogram
server <- function(input, output) {

  output$Dragula <- renderDragula({
    dragula(c("drag1", "drag2"))
  })

  output$text <- renderPrint({
    input$Dragula_state
  })

  output$iris = renderPlot({plot(iris)})
  output$mtcars = renderPlot({plot(mtcars)})
  output$AirPassengers = renderPlot({plot(AirPassengers)})
  output$Formaldehyde = renderPlot({plot(Formaldehyde)})
  output$USArrests = renderPlot({plot(USArrests)})
}

# Run the application
shinyApp(ui = ui, server = server)

