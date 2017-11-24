#' Register containers to dragula.
#'
#' Create dragula instace to allow moving around elements of the registered containers.
#'
#' @param x vector of containers ids. Their's elements will become draggable.
#' @param id input id to read from in shiny.
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


#' Format dragula input object.
#'
#' @param x dragula input.
#'
#' @description
#' This is a utility function for better formatting dragula's input.
#'
#' @export
#' @importFrom utils tail
#' @examples
#'
#' \dontrun{
#' # Example call:
#' dragulaValue(input$dragula)
#' }
#'
dragulaValue <- function(x) {
  x <- lapply(x, unlist)
  names(x) <- vapply(
    names(x),
    FUN.VALUE = "",
    function(y) tail(strsplit(y, split = "-")[[1]],1))
  x
}


#' Register dragulaR's js functions for refreshing dragula object.
#'
#' @export
#' @importFrom shinyjs extendShinyjs
#' @examples
#'
#' \dontrun{
#' # See example for more details
#' library(dragulaR)
#' runApp(
#'   system.file("apps/example05-dragula-dynamic-elements", package = "dragulaR"),
#'   display.mode = "showcase")
#' }
#'
useDragulajs <- function() {
  shinyjs::extendShinyjs(text = "shinyjs.refreshDragulaR = function(params) {
    dragulaR.get(params[0])()
}")
}

