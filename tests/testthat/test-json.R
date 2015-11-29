library(testthatsomemore)
context("json")

test_that("simplify_homogeneous_lists can simplify homogeneous lists", {
  test_obj <- list(list(1,2), list(1, 'a'))
  goal_obj <- list(c(1,2), list(1, 'a'))
  expect_identical(simplify_homogeneous_lists(test_obj), goal_obj)
})

test_that("simplify_homogeneous_lists can figure out what to do with NULL list elements", {
  test_obj <- list(a = 1, b = '2', c = NULL, d = NULL)
  goal_obj <- list(a = 1, b = '2', c = NA, d = NA)
  expect_identical(simplify_homogeneous_lists(test_obj), goal_obj)
})

test_that("simplify_homogeneous_lists can impute NULLs in nested lists", {
  test_obj <- list(list(a = 1, b = 2, c = NULL), list(a = 'a', b = 'b', c = NULL))
  goal_obj <- simplify_homogeneous_lists(test_obj)
  first  <- c(a = 1, b = 2, c = NA)
  second <- c(a = 'a', b = 'b', c = NA_character_)
  expect_true(all.equal(first, goal_obj[[1]]))
  expect_true(all.equal(second, goal_obj[[2]]))
  # redundant check, but nonetheless
  expect_true(all.equal(goal_obj, list(first, second)))
})

test_that("simplify_homogeneous_lists returns the object if the object is NULL", {
  expect_identical(NULL, simplify_homogeneous_lists(NULL))
})

test_that("to_json correctly handles deeply nested, named, atomic vectors", {
  expect_identical(to_json(list(alice = 5, bob = c(charlie = 27))),
                   "{\"alice\":5,\"bob\":{\"charlie\":27}}")
})

describe("common_types", {
  test_that("common_types returns the common type", {
    expect_equal("numeric", common_type(list(1, 2)))
  })
  test_that("common_types returns NA if there are no common types", {
    expect_equal(NA_character_, common_type(list(1, "a")))
  })
})
