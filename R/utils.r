`%||%` <- function(x, y) if (is.null(x)) y else x

#' Fix jsonlite's JSON simplification.
#'
#' @param object any R object derived from \code{\link[jsonlite]{fromJSON}}.
#' @return the same object, with any list components where each element is
#'   an atomic vector of length 1 or NULL coerced to a single atomic vector.
#' @examples
#' \dontrun{
#'   simplify_homogeneous_lists(jsonlite::fromJSON(
#'    '{ "numeric": [1,2], "list": [1, "a"] }', simplifyVector = FALSE))
#'   # A list with atomic numeric vector in the "numeric" key and 
#'   # a list in the "list" key.
#'   # list(numeric = c(1,2), list = list(1, "a"))
#' }
simplify_homogeneous_lists <- function(object) {
  if (is.list(object)) {
    if (all(vapply(object, terminal, logical(1)))) {
      type <- common_type(object)
      if (identical(type, "NULL")) { object }
      else if (is.na(type)) { object }
      else { 
        vapply(object, identity, vector(type, 1))
      }
    } else {
      lapply(object, simplify_homogeneous_lists)
    }
  } else { object }
}

terminal <- function(x) {
  is.null(x) || (is.atomic(x) && length(x) == 1)
}

common_type <- function(x) {
  types <- vapply(Filter(Negate(is.null), x), class, character(1))
  if (length(types) == 0) { "NULL" }
  else if (length(unique(types)) == 1) { types[1] }
  else { NA }
}

