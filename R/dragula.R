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
