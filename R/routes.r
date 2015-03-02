#' Determine the correct route to use based on a list of routes and
#' the current request_path.
#'
#' For example,
#' \code{list('/ping' = function(params, query) 'Hello world!',
#'            function(params, query) 'Invalid route.'))}
#' refers to a /ping route and a default route  'Invalid route.'
#'
#' @param routes list. A named list of routes.
#' @param request_path character. The path to which the request was sent.
#' @return the correct route drawn from the routes list
determine_route <- function(routes, request_path) {
  stopifnot(is.list(routes))
  serve_static <- routes$serve_static %||% FALSE
  has_unnamed_route <-
    (identical(names(routes), NULL) && length(routes) != 0) || '' %in% names(routes)
  routenames <- names(routes)[names(routes) != '']
  for (route in routenames) {
    if (grepl(paste0('^', route), request_path)) {
      return(routes[[route]])
    } else if (serve_static && file.exists(paste0("public", request_path))) {
      return(fetch_asset(request_path))
    }
  }

  # Use root route by default
  if (has_unnamed_route) {
    if (identical(names(routes), NULL)) routes[[1]]
    else routes[[which('' == names(routes))[1]]]
  } else function(params, query) microserver_response(status = 404)
}

fetch_asset <- function(asset_path) {
  payload <- paste0(readLines(paste0("public", asset_path)), collapse=" ")
  microserver_response(payload, headers = list("content-type" = "text/html"))
}
