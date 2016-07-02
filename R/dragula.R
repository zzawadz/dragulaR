#' Dragula
#'
#' Dragula
#'
#' @import htmlwidgets
#'
#' @export
dragula <- function(x = list(c(1:5), c(10:11)), width = NULL, height = NULL) {

  names(x) = NULL

  simple = FALSE
  if(is.character(x))
  {
    simple = TRUE
    width  = "0px"
    height = "0px"
  }

  # forward options using x
  x = list(
    x = x,
    simple = simple
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'dragula',
    x,
    width = width,
    height = height,
    package = 'dragulaR'
  )
}

#' Shiny bindings for dragula
#'
#' Output and render functions for using dragula within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a dragula
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name dragula-shiny
#'
#' @export
dragulaOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'dragula', width, height, package = 'dragulaR')
}

#' @rdname dragula-shiny
#' @export
renderDragula <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, dragulaOutput, env, quoted = TRUE)
}

