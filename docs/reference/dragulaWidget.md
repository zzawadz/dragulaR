# Dragula widget.

Create dragula widget.

## Usage

``` r
dragulaOutput(outputId)

renderDragula(expr, env = parent.frame(), quoted = FALSE)
```

## Arguments

- outputId:

  output variable to read from.

- expr:

  An expression that generates a dragula object.

- env:

  The environment in which to evaluate `expr`.

- quoted:

  Is `expr` a quoted expression (with
  [`quote()`](https://rdrr.io/r/base/substitute.html))? This is useful
  if you want to save an expression in a variable.

## Value

`dragulaOutput` returns a Shiny tag list for the UI. `renderDragula`
returns a Shiny render function for the server.

## Examples

``` r
if(interactive()) {
  path <- system.file("apps/example02-input", package = "dragulaR")
  runApp(path, display.mode = "showcase")
}
```
