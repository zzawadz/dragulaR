library(shiny)
library(dragulaR)
library(shinyjs)

datasets <- list(iris = iris, mtcars = mtcars)

help <- "Refreshing dragula after renderUI is a bit problematic.
In the current version, the user needs to perform any action (change the order of values in the dragula's container or move elements around)
to refresh input$dragula state.

You can see this behavior by at the verbatimTextOutput, containing a list with elements names in each dragula container.

It might be not a real problem because there might be other conditions that must be met to proceed.
In this case, the plot disappears because of all columns from elementsOutput must match names from the dataset."

ui <- fluidPage(
  useShinyjs(),
  useDragulajs(),
  titlePanel("Add elements using render ui"),
  selectInput(inputId = "dataset", label = "Select data set:", selected = "iris", choices = c("iris", "mtcars")),
  helpText(help),
  verbatimTextOutput("order"),
  fluidRow(
    column(width = 3, h2("Input"), uiOutput("elementsInput", style = "min-height:200px;background-color:grey;")),
    column(width = 3, h2("Output"), uiOutput("elementsOutput", style = "min-height:200px;background-color:grey;")),
    column(width = 6, plotOutput("plot"))
  ),
  dragula(c("elementsInput", "elementsOutput"), id = "dragula")
)

server <- function(input, output) {

  output$order <- renderPrint({
    req(input$dataset)
    dragulaValue(input$dragula)
  })


  output$elementsInput <- renderUI({

    req(input$dataset)
    lapply(colnames(datasets[[input$dataset]]), function(nm) tags$h3(drag = nm, nm))

  })

  output$elementsOutput <- renderUI({
    # reset elementsOutput after dataset changes
    req(input$dataset)
    div()
  })

  output$plot <- renderPlot({
    req(input$dataset)
    out <- dragulaValue(input$dragula)$elementsOutput
    req(out, all(out %in% colnames(datasets[[input$dataset]])))
    dt <- datasets[[input$dataset]][,out, drop = FALSE]
    plot(dt)
  })


}

shinyApp(ui = ui, server = server)

