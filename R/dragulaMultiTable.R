#' Dragula
#'
#' Dragula
#'
#' @import htmlwidgets
#'
#' @export
dragulaMultiTable <- function(x = list(c(1:5), c(10:11)), width = NULL, height = NULL) {

  # forward options using x
  x = list(
    x = x
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'dragulaMultiTable',
    x,
    width = width,
    height = height,
    package = 'dragulaR'
  )
}

#' Shiny bindings for dragulaMultiTable
#'
#' Output and render functions for using dragulaMultiTable within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a dragulaMultiTable
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name dragulaMultiTable-shiny
#'
#' @export
dragulaMultiTableOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'dragulaMultiTable', width, height, package = 'dragulaR')
}

#' @rdname dragula-shiny
#' @export
renderDragulaMultiTable <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, dragulaMultiTableOutput, env, quoted = TRUE)
}

