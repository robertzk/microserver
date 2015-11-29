context("html")

describe("html", {
  test_that("it returns an HTML string", {
    html_string <- html("<b>BOLD!</b>")
    expect_true(is.microserver_response(html_string))
    expect_equal(200, html_string$status)
    expect_equal("text/html", html_string$headers$`content-type`)
    expect_equal("<b>BOLD!</b>", html_string$body)
  })
})

describe("html_page", {
  test_that("It errors if it cannot find the HTML file", {
    expect_error(html_page("noexist.html")())
  })
  test_that("it returns the HTML within that file", {
    with_mock(`readLines` = function(...) "<b>BOLD!</b>",
      html_string <- html_page("bold.html")(),
      expect_true(is.microserver_response(html_string)),
      expect_equal(200, html_string$status),
      expect_equal("text/html", html_string$headers$`content-type`),
      expect_equal("<b>BOLD!</b>", html_string$body)
  ) })
})

describe("from_url", {
  test_that("it fetches an item", {
    expect_equal(c(body = "1"), from_url("body=1"))
  })
})
