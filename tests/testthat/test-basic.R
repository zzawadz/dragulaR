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
