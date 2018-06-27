context("Basic")

test_that("Create new object", {
  expect_s3_class(dragula("x"), "dragula")
  expect_error(dragula())
  expect_error(dragula(c(1,2,3)))
})

test_that("Create new object", {
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

