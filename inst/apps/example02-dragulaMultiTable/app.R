library(shiny)
library(dragulaR)

ui <- fluidPage(

        fluidRow(verbatimTextOutput("dragVals")),
        fluidRow(dragulaMultiTableOutput("drag"))

)

server <- function(input, output) {

  output$drag = renderDragulaMultiTable({
      tmp = list(colnames(iris), colnames(mtcars))
      dragulaMultiTable(tmp)
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

}

shinyApp(ui = ui, server = server)

