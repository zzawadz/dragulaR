#' Dragula
#'
#' Dragula
#'
#' @importFrom htmlwidgets createWidget
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
