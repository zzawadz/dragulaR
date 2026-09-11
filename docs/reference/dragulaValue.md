# Format dragula input object.

This is a utility function for better formatting dragula's input. It
extracts the container names and their element order from the raw input
object.

## Usage

``` r
dragulaValue(x)
```

## Arguments

- x:

  dragula input.

## Value

A named list where names are container IDs and values are character
vectors of element identifiers (from the `drag` attribute).

## Examples

``` r
if (FALSE) { # \dontrun{
# Example call:
dragulaValue(input$dragula)
} # }
```
