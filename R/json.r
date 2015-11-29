#' Convert an object into JSON.
to_json <- function(obj) {
  obj2 <- recursively_enlist_if_named(obj)
  as.character(jsonlite::toJSON(obj2, auto_unbox = TRUE))
}

#' Convert an object from JSON into an R object.
from_json <- function(obj) {
  simplify_homogeneous_lists(jsonlite::fromJSON(obj, simplifyVector = FALSE))
}

#' Check if an object has names.
has_names <- function(obj) {
  !is.null(names(obj)) && !is.null(Find(function(s) !is.na(s) && (s != ""), names(obj)))
}

#' Coerce an object into a particular type.
coerce <- function(obj, type) {
  if (is.null(obj)) { as(NA, type) } else { as(obj, type) }
}

#' Convert an object to a list, but only if that object has names.
enlist_if_named <- function(obj) {
  if (is.atomic(obj) && has_names(obj)) as.list(obj) else obj
}

recursively_enlist_if_named <- function(obj) {
  if (is.atomic(obj) || length(obj) == 0) enlist_if_named(obj)
  else lapply(obj, recursively_enlist_if_named)
}

#' Fix jsonlite's JSON simplification.
#'
#' @param object any R object derived from \code{\link[jsonlite]{fromJSON}}.
#' @param simple_check logical. This is needed to modify behavior for recursive function call.
#' @return the same object, with any list components where each element is
#'   an atomic vector of length 1 or NULL coerced to a single atomic vector.
#' @note See \href{https://github.com/jeroenooms/jsonlite/issues/66}{the related GitHub issue} for more details.
#' @examples
#' \dontrun{
#'   simplify_homogeneous_lists(jsonlite::fromJSON(
#'    '{ "numeric": [1,2], "list": [1, "a"] }', simplifyVector = FALSE))
#'   # A list with atomic numeric vector in the "numeric" key and
#'   # a list in the "list" key.
#'   # list(numeric = c(1,2), list = list(1, "a"))
#' }
simplify_homogeneous_lists <- function(object, simple_check = TRUE) {
  if (isTRUE(simple_check) && is_simple_list(object)) { return(try_simplify(object)) }
  if (is.list(object)) {
    if (all(vapply(object, terminal, logical(1)))) {
      type <- common_type(object)
      if (identical(type, "NULL")) { object }
      else if (is.na(type)) { object }
      else {
        vapply(object, coerce, vector(type, 1), type)
      }
    } else {
      lapply(object, simplify_homogeneous_lists, simple_check = FALSE)
    }
  } else { object }
}

try_simplify <- function(lst) {
  if (any(vapply(lst, is.null, logical(1)))) { denull(lst) } else { simplify_homogeneous_lists(lst, simple_check = FALSE) }
}

common_type <- function(x) {
  types <- vapply(Filter(Negate(is.null), x), class, character(1))
  if (length(types) == 0) { "NULL" }
  else if (length(unique(types)) == 1) { types[1] }
  else { NA_character_ }
}

#' TRUE or FALSE if the object is a terminal.
#' A terminal is either a NULL or a length-1 atomic.
terminal <- function(x) {
  is.null(x) || (is.atomic(x) && length(x) == 1)
}

#' Turn NULL into NA.
denull <- function (lst) {
  Map(function(x) { if (is.null(x)) NA else x }, lst)
}

#' Check if an object is a simple list (i.e., it is a list, but not a list of lists).
is_simple_list <- function(lst) {
  is.list(lst) && all(vapply(lst, Negate(is.list), logical(1))) && all(vapply(lst, length, numeric(1)) <= 1)
}
