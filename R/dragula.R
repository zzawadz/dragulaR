#' Dragula
#'
#' Dragula
#'
#' @importFrom htmlwidgets createWidget shinyWidgetOutput shinyRenderWidget
#'
#' @export
dragula <- function(x) {

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
  createWidget(
    name = 'dragula',
    x,
    width = width,
    height = height,
    package = 'dragulaR'
  )
}

#' @export
dragulaOutput <- function(outputId, width = "100%", height = "400px") {
  shinyWidgetOutput(outputId, "dragula", width = "0px", height = "0px", package = "dragulaR")
}

#' @export
renderDragula <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, dragulaOutput, env, quoted = TRUE)
}
