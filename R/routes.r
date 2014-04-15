#' Determine the correct route to use based on a list of routes and
#' the current path.
#'
#' For example,
#' \code{list('/ping' = function(params, query) 'Hello world!',
#'            function(params, query) 'Invalid route.'))}
#' refers to a /ping route and a default route  'Invalid route.'
#'
#' @param routes list. A named list of routes.
#' @param path character. The path to wich the request was sent.
determine_route <- function(routes, path) {
  stopifnot(is.list(routes))
  has_unnamed_route <-
    (names(routes) == NULL && length(routes) == 0) || !'' %in% names(routes)
  root <-
    if (has_unnamed_route) {
      if (names(routes) == NULL) routes[[1]]
      else routes[[which('' %in% names(routes))[1]]]
    } else function(params, query) list(status = 400)

  routenames <- names(routes)[names(routes) != '']
  for (route in routenames) {
    route <- paste0('^', route)    
  }
}

