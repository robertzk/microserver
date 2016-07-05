library(testthatsomemore)
context('extract params from request')

test_that('it returns NULL for an empty example', {
  request <- list(rook.input = list(read_lines = function() ''))
  expect_identical(extract_params_from_request(request), NULL)
})

test_that('it returns an ERROR for an invalid JSON', {
  request <- list(rook.input = list(read_lines = function() 'invalid JSON'))
  expect_is(extract_params_from_request(request), 'simpleError')
})

test_that('it returns the correct parameter list for a simple correct example', {
  request <- list(rook.input = list(read_lines = function()
    '{"example": "JSON", "number": 5, "numeric": [1,2], "list": [1, "a"] }'))
  expect_equal(extract_params_from_request(request),
               list(example = "JSON", number = 5, numeric = c(1,2), list = list(1, 'a')))
})

context('extract query from request')

test_that('it returns NULL for an empty query', {
  expect_identical(extract_query_from_request(list(QUERY_STRING = NULL)), NULL)
  expect_identical(extract_query_from_request(list(QUERY_STRING = '')), NULL)
})

test_that('it returns correctly for a 1-argument query', {
  expect_identical(extract_query_from_request(list(QUERY_STRING = 'a=1')), list(a='1'))
})

test_that("it returns correctly for a 1-argument query with a '=' in the value", {
  expect_identical(extract_query_from_request(list(QUERY_STRING = 'a=1=2')), list(a='1=2'))
})

test_that('it returns correctly for a 2-argument query', {
  expect_identical(extract_query_from_request(list(QUERY_STRING = 'a=1&b=2')), list(a='1',b='2'))
})

test_that('it can decode URL characters', {
  expect_identical(extract_query_from_request(list(QUERY_STRING = 'a=1%202')), list(a='1 2'))
})
