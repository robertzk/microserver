context('determine_route')

test_that('it determines the root 404 route for a trivial example', {
  expect_identical(determine_route(list(), '')()$status, 404)
})

test_that('it determines the ping route for a simple example', {
  expect_identical(determine_route(list('/ping' = function() 'Hello world'), '/ping')(),
                                   'Hello world')
})

test_that('it determines the root 404 route for a simple example', {
  expect_identical(determine_route(
    list('/ping' = function() 'Hello world'), '/notping')()$status, 404)
})

test_that('it determines the root route for a simple example', {
  expect_identical(determine_route(list('/ping' = function() 'Hello world',
                                        function() 'Index page'), '/notping')(),
                                   'Index page')
})

test_that('it can serve a closure', {
  expect_identical(determine_route(
    list('/ping' = function(p,q){(function(){"pong"})()}), '/ping')(), "pong")
})
