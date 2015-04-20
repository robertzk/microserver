library(testthatsomemore)
context("determine_route")

test_that("it determines the root 404 route for a trivial example", {
  expect_identical(determine_route(list(), "")()$status, 404)
})

test_that("it determines the ping route for a simple example", {
  expect_identical(determine_route(list("/ping" = function() "Hello world"), "/ping")(),
                                   "Hello world")
})

test_that("it determines the root 404 route for a simple example", {
  expect_identical(determine_route(
    list("/ping" = function() "Hello world"), "/notping")()$status, 404)
})

test_that("it determines the root route for a simple example", {
  expect_identical(determine_route(list("/ping" = function() "Hello world",
                                        function() "Index page"), "/notping")(),
                                   "Index page")
})

test_that("it cannot fetch the file for an asset if it doesn't exist", {
  expect_identical(determine_route(list(serve_static = TRUE), "index.html")()$status, 404)
})

test_that("it fetches the file for an asset if it exists", {
  within_file_structure(list(public = list("index.html" = "I am a real file!")), {
    resp <- in_dir(tempdir, determine_route(list(serve_static = TRUE), "index.html"))
    expect_identical(resp$body, "I am a real file!")
  })
})

test_that('it can serve a closure', {
  expect_identical(determine_route(
    list('/ping' = function(p,q){(function(){"pong"})()}), '/ping')(), "pong")
})
