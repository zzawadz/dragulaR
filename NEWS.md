# dragulaR 0.3.3 (development version)

## New features

* `dragula()` gains a `maxItems` shortcut option for limiting how many elements
  a container will accept, e.g. `dragula(c("Available", "Model"), maxItems =
  list(Model = 3))` (#4). A new example app, `example08-max-items`, demonstrates
  it.
* The example apps are published as a static Shinylive site that runs entirely
  in the browser. `tools/build-shinylive.R` exports every app in `inst/apps/`
  and a GitHub Actions workflow deploys the result to GitHub Pages.

## Bug fixes

* `dragulaValue()` now returns `character(0)` for an empty container instead of
  dropping it from the result, so the returned list always has one entry per
  registered container.
* `useDragulajs()` passes `functions = "refreshDragulaR"` to
  `shinyjs::extendShinyjs()`, which recent versions of shinyjs require for
  `js$refreshDragulaR()` to be defined.
* Calling `dragula()` with no options no longer sends an empty JSON array where
  the dragula JavaScript library expects an options object.
* The `accepts` wrapper installed by `maxItems` no longer fails when dragula
  calls it with a `null` target (an element dragged outside any container).
* The JavaScript code checks that registered container ids actually exist in the
  document before using them.
* Examples 02 and 07 call `library(dragulaR)`; they previously only worked if
  the package happened to be attached already.
* Fixed the `runApp()` paths for example 07 in the README - the directory is
  `example07-input-options`.

## Other changes

* `JS()` is imported from htmlwidgets instead of V8, dropping the V8 dependency.
  `V8::JS` is a verbatim copy of `htmlwidgets::JS`, so this is a no-op at
  runtime, but it removes a compiled dependency and makes the package loadable
  under webR/Shinylive, where V8 has no WebAssembly build.
* Expanded test coverage for `dragulaValue()`, `copyOnly` and `maxItems`.
* Documentation regenerated with roxygen2 8.1.0; added `Encoding: UTF-8` to
  DESCRIPTION and return-value documentation for all exported functions.
* Added `AGENTS.md` with guidelines for AI agents working on the package.

# dragulaR 0.3.2

* `dragula()` accepts arbitrary dragula JavaScript options through `...`, which
  are forwarded to the JavaScript library (thanks to Darren Maczka). `id` is
  still handled as the Shiny input id.
* Added the `copyOnly` shortcut option, which makes a container a source that
  elements are copied from rather than moved out of, together with the
  `example07-input-options` app.
* Darren Maczka added to the authors list as a contributor.

# dragulaR 0.3.1

* First CRAN release.
* `R CMD check` cleanups.

# dragulaR 0.3.0

* License changed from MIT to GPL-2.
* Title and description reworded for CRAN; added `BugReports` and `URL` fields.

# dragulaR 0.2.0

* `dragula(x, id = NULL)` now takes a vector of container ids and registers them
  with a single dragula instance; elements carrying a `drag` attribute are the
  ones tracked.
* Added `dragulaValue()` for turning the raw `input$dragula` object into a named
  list of container ids and element order.
* Added `useDragulajs()` and the `js$refreshDragulaR()` JavaScript function for
  refreshing dragula after elements are added dynamically with `insertUI()` or
  `renderUI()`.
* The widget waits for Shiny to finish initialising before rendering.
* Added example apps covering basic usage, Shiny inputs, element order, Shiny
  modules and dynamically inserted elements.
* Added test suite, pkgdown site and CI (Travis, AppVeyor, codecov).
* Updated the bundled dragula JavaScript library.

# dragulaR 0.1.0

* First version: `dragula()`, `dragulaOutput()` and `renderDragula()` wrapping
  the dragula JavaScript library as an htmlwidget.
