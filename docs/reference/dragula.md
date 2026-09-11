# Register containers to dragula.

Create dragula instace to allow moving around elements of the registered
containers.

## Usage

``` r
dragula(x, ...)
```

## Arguments

- x:

  vector of containers ids. Their's elements will become draggable.

- ...:

  additonal arguments passed to dragula JS as options. E.g. `id` will be
  an id to read from in shiny. Additional shortcut options:

  - `copyOnly`: container id from which elements can only be copied (not
    moved)

  - `maxItems`: named list specifying maximum items per container, e.g.
    `maxItems = list(Model = 3)`

## Value

Return htmlWidget. Should be used only inside shiny ui.

## Examples

``` r
if(interactive()) {
  # Basic example
  path <- system.file("apps/example01-dragula", package = "dragulaR")
  runApp(path, display.mode = "showcase")

  # Example with maxItems (limits Model container to 3 items)
  path <- system.file("apps/example08-max-items", package = "dragulaR")
  runApp(path, display.mode = "showcase")
}

# Create dragula with maxItems limit
if (FALSE) { # \dontrun{
dragula(c("Available", "Model"), maxItems = list(Model = 3))
} # }
```
