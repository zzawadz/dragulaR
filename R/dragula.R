#' Dragula
#'
#' Dragula
#'
#' @import htmlwidgets
#'
#' @export
dragula <- function(x, width = NULL, height = NULL) {

  if(!is.character(x))
  {
    stop("x must be a character vector!")
  }

  names(x) = NULL

  width  = "0px"
  height = "0px"

  # forward options using x
  x = list(
    x = x
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
dragulaOutput <- function(outputId, width = '0px', height = '0px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'dragula', width, height, package = 'dragulaR')
}

#' @rdname dragula-shiny
#' @export
renderDragula <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, dragulaOutput, env, quoted = TRUE)
}

