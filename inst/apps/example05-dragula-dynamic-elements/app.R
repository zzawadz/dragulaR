library(shiny)
library(dragulaR)
library(shinyjs)

ui <- fluidPage(
        useShinyjs(),
        useDragulajs(),
        titlePanel("Add new elements to container elements"),
        verbatimTextOutput("order"),
        actionButton("Add", label = "Add"),
        fluidRow(id = "elements",
                 div(id = "placeholder")),
        dragula("elements", id = "dragula")
)

server <- function(input, output) {

  output$order <- renderPrint({
    dragulaValue(input$dragula)
  })
  counter <- reactiveVal(0)

  observeEvent(input$Add, {
    id <- counter()
    element <- div(drag = id, tags$h3(paste("Element", id)))
    insertUI(selector = "#placeholder", where = "beforeBegin", ui = element, immediate = TRUE)
    counter(id + 1)
    js$refreshDragulaR("dragula")

  })

}

shinyApp(ui = ui, server = server)

