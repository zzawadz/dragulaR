#' Register containers to dragula.
#'
#' Create dragula instace to allow moving around elements of the registered containers.
#'
#' @param x vector of containers ids. Their's elements will become draggable.
#'
#' @importFrom htmlwidgets createWidget shinyWidgetOutput shinyRenderWidget
#' @import shiny
#' @export
#' @return
#' Return htmlWidget. Should be used only inside shiny ui.
#'
#' @examples
#'
#' if(interactive()) {
#'   path <- system.file("apps/example01-dragula", package = "dragulaR")
#'   runApp(path, display.mode = "showcase")
#' }
#'
dragula <- function(x, id = NULL) {

  if(!is.character(x))
  {
    stop("x must be a character vector!")
  }

  names(x) = NULL

  width  = "0px"
  height = "0px"

  # forward options using x
  x = list(
    x = x,
    elid = id
  )

  # create widget
  createWidget(
    name = 'dragula',
    x,
    width = width,
    height = height,
    package = 'dragulaR'
  )
}

#' Dragula widget.
#'
#' Create dragula widget.
#'
#' @param outputId output variable to read from.
#' @param expr An expression that generates a dragula object.
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @return RETURN_DESCRIPTION
#' @rdname dragulaWidget
#' @export
#' @examples
#'
#' if(interactive()) {
#'   path <- system.file("apps/example02-input", package = "dragulaR")
#'   runApp(path, display.mode = "showcase")
#' }
#'
dragulaOutput <- function(outputId) {
  shinyWidgetOutput(outputId, "dragula", width = "0px", height = "0px", package = "dragulaR")
}

#' @export
#' @rdname dragulaWidget
renderDragula <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, dragulaOutput, env, quoted = TRUE)
}
