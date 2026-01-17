context("Basic")

test_that("Create new object", {
  expect_s3_class(dragula("x"), "dragula")
  expect_error(dragula())
  expect_error(dragula(c(1,2,3)))
})

test_that("Create dragula with multiple containers", {
  result <- dragula(c("container1", "container2", "container3"))
  expect_s3_class(result, "dragula")
  expect_equal(result$x$x, c("container1", "container2", "container3"))
})

test_that("Widget output functions", {
  expect_s3_class(dragulaOutput("x"), "shiny.tag.list")
  expect_s3_class(renderDragula({dragula("x1")}), "shiny.render.function")
})

test_that("useDragulajs", {
  expect_s3_class(useDragulajs(), "shiny.tag.list")
})

test_that("dragula value", {
  output <- structure(
    list(plots = c("mtcars", "iris", "AirPassengers", "Formaldehyde")),
    .Names = "plots")
  input <- structure(
    list(`foo-plots` = list("mtcars", "iris", "AirPassengers","Formaldehyde")),
    .Names = "foo-plots")

  expect_equal(dragulaValue(input), output)
})

test_that("dragulaValue handles multiple containers", {
  input <- list(
    `ns-Available` = list("a", "b", "c"),
    `ns-Model` = list("x", "y")
  )
  result <- dragulaValue(input)

  expect_equal(names(result), c("Available", "Model"))
  expect_equal(result$Available, c("a", "b", "c"))
  expect_equal(result$Model, c("x", "y"))
})

test_that("dragulaValue handles empty containers", {
  input <- list(
    `ns-Available` = list("a", "b"),
    `ns-Empty` = list()
  )
  result <- dragulaValue(input)

  expect_equal(result$Available, c("a", "b"))
  expect_equal(result$Empty, character(0))
})

context("Options")

test_that("dragula with custom id", {
  result <- dragula("container", id = "myDragula")
  expect_equal(result$x$elid, "myDragula")
})

test_that("copyOnly option generates correct JS functions", {
  result <- dragula(c("Source", "Target"), copyOnly = "Source")

  # Check that copy and accepts are JS functions
  expect_s3_class(result$x$settings$copy, "JS_EVAL")
  expect_s3_class(result$x$settings$accepts, "JS_EVAL")

  # Check that copyOnly was removed from settings
  expect_null(result$x$settings$copyOnly)
})

test_that("removeOnSpill option is passed correctly", {
  result <- dragula("container", removeOnSpill = TRUE)
  expect_true(result$x$settings$removeOnSpill)
})

context("maxItems option")

test_that("maxItems option is stored correctly", {
  result <- dragula(
    c("Available", "Model"),
    maxItems = list(Model = 3)
  )

  expect_equal(result$x$maxItems, list(Model = 3))
  # maxItems should not be in settings
  expect_null(result$x$settings$maxItems)
})

test_that("maxItems with multiple containers", {
  result <- dragula(
    c("A", "B", "C"),
    maxItems = list(B = 5, C = 2)
  )

  expect_equal(result$x$maxItems$B, 5)
  expect_equal(result$x$maxItems$C, 2)
})

test_that("maxItems requires named list", {
  expect_error(
    dragula("x", maxItems = c(3, 5)),
    "maxItems must be a named list"
  )

  expect_error(
    dragula("x", maxItems = list(3, 5)),
    "maxItems must be a named list"
  )
})

test_that("maxItems works with other options", {
  result <- dragula(
    c("Source", "Target"),
    copyOnly = "Source",
    maxItems = list(Target = 3),
    removeOnSpill = TRUE
  )

  expect_s3_class(result$x$settings$copy, "JS_EVAL")
  expect_s3_class(result$x$settings$accepts, "JS_EVAL")
  expect_true(result$x$settings$removeOnSpill)
  expect_equal(result$x$maxItems, list(Target = 3))
})

