library(testthatsomemore)
context("response")

test_that("it returns an ERROR message on invalid JSON", {
  resp <- microserver_response(new.env())
  expect_identical(resp$status, 500)
  expect_identical(from_json(resp$body)[["status"]], "error")
})

test_that("it returns a 200 response when given a character response", {
  resp <- microserver_response("hello")
  expect_identical(resp$status, 200)
  expect_identical(from_json(resp$body), "hello")
})

test_that("it returns an exotic response correctly", {
  exotic <- microserver_response("Im a teapot", 418, list("content-type" = "teapot"))
  exotic2 <- list(body = "Im a teapot", status = 418, headers = list("content-type" = "teapot"))
  class(exotic2) <- "microserver_response"
  expect_identical(exotic, exotic2)
})

test_that("it returns a 200 response with a correctly encoded JSON response for a list", {
  resp <- microserver_response(list(a = 1, b = 2))
  expect_identical(resp$status, 200)
  expect_equal(from_json(resp$body), c(a = 1, b = 2))
})

test_that("it returns a 200 response and gives raw html", {
  resp <- microserver_response("hello I am <p>HTML</p>", headers = list("content-type" = "text/html"))
  expect_identical(resp$status, 200)
  expect_identical(resp$body, "hello I am <p>HTML</p>")
})

describe("is.microserver_response", {
  test_that("returns FALSE if it is not a microserver response", {
    expect_false(is.microserver_response("hi"))
  })
  test_that("returns TRUE if it is a microserver response", {
    expect_true(is.microserver_response(microserver_response("hi")))
  })
})
