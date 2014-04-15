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
#' @return the correct route drawn from the routes list
determine_route <- function(routes, path) {
  stopifnot(is.list(routes))
  has_unnamed_route <-
    (identical(names(routes), NULL) && length(routes) != 0) || '' %in% names(routes)
  routenames <- names(routes)[names(routes) != '']
  for (route in routenames) {
    if (grepl(paste0('^', route), path)) return(routes[[route]])
  }

  # Use root route by default
  if (has_unnamed_route) {
    if (identical(names(routes), NULL)) routes[[1]]
    else routes[[which('' == names(routes))[1]]]
  } else function(params, query) microserver_response(status = 404)
}

