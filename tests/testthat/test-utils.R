library(testthatsomemore)
context('utils')

test_that('simplify_homogeneous_lists can simplify homogeneous lists', {
  test_obj <- list(list(1,2), list(1, 'a'))
  goal_obj <- list(c(1,2), list(1, 'a'))
  expect_identical(simplify_homogeneous_lists(test_obj), goal_obj)
})

test_that('to_json correctly handles deeply nested, named, atomic vectors', {
  expect_identical(to_json(list(alice = 5, bob = c(charlie = 27))),
                   "{\"alice\":5,\"bob\":{\"charlie\":27}}")
})
