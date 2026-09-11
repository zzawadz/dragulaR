# Register dragulaR's js functions for refreshing dragula object.

This function enables the `js$refreshDragulaR()` JavaScript function in
Shiny, which should be called after dynamically adding elements to a
dragula container.

## Usage

``` r
useDragulajs()
```

## Value

A Shiny tag list that registers the JavaScript extension.

## Examples

``` r
if (FALSE) { # \dontrun{
# See example for more details
library(dragulaR)
runApp(
  system.file("apps/example05-dragula-dynamic-elements", package = "dragulaR"),
  display.mode = "showcase")
} # }
```
