library(shinydashboard)
library(dragulaR)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody(
    box(width = 6, id = "drag1", title = "Drag1",
      box(width = 12, plotOutput("iris")),
      box(width = 12, plotOutput("mtcars")),
      box(width = 12, plotOutput("AirPassengers")),
      box(width = 12, plotOutput("Formaldehyde"))
    ),
    box(width = 6, id = "drag2", title = "Drag2",
        box(width = 12, plotOutput("USArrests"))),
    dragula(c("drag1", "drag2"))
  )
)
# Define server logic required to draw a histogram
server <- function(input, output) {

  output$iris = renderPlot({plot(iris)})
  output$mtcars = renderPlot({plot(mtcars)})
  output$AirPassengers = renderPlot({plot(AirPassengers)})
  output$Formaldehyde = renderPlot({plot(Formaldehyde)})
  output$USArrests = renderPlot({plot(USArrests)})
}

# Run the application
shinyApp(ui = ui, server = server)

