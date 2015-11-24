#' Default http server configuration for libuv hook.
#'
#' @param routes list. A named list of routes, with a handler
#'    function for each route. The first unnamed route will be used
#'    as the root. If none is provided, just a 404 status will be returned.
#' @examples
#' \dontrun{
#'   http_server(list('/ping' = function(params, query) 'Hello world!',
#'                    function(params, query) 'Invalid route.'))
#' }
http_server <- function(routes) {
  function(req) {
    params <- extract_params_from_request(req)
    query  <- extract_query_from_request(req)
    route  <- determine_route(routes, req$PATH_INFO)
    if (is.microserver_response(route)) return(unclass(route))
    environment(route) <- list2env(list(.server_env = environment()), parent = environment(route))
    result <- route(params, query)
    if (is.microserver_response(result)) unclass(result)
    else unclass(microserver_response(result))
  }
}


#' Returns HTML in a server.
#'
#' @param html_string character. A sring of HTML.
#' @examples
#' \dontrun{
#'    routes <- list("/index" = function(...) html("<b>bold!</b>"))
#' }
#' @export
html <- function(html_string) {
  microserver_response(html_string, headers = list("content-type" = "text/html"))
}


#' Minimal function for opening a socket and accepting/responding to
#' requests.
#'
#' @param routes list. A named list of routes.
#' @param port integer. The default is 8103.
#' @param http_basic_auth list. A list of HTTP basic authentication requirements.
#'     If not \code{NULL} (the default), should contain a \code{token} and
#'     \code{routes} key.
#' @export
run_server <- function(routes, port = 8103, http_basic_auth = NULL) {
  on_headers <- if (is.null(http_basic_auth)) {
      ## if http_basic_auth is NULL - no authentication
      function(req) { NULL }
    } else {
      ## else - pass in a list that has password and a list of routes to be protected
      stopifnot(is.list(http_basic_auth) && all(c('token', 'routes') %in% names(http_basic_auth)))
      function(req) {
        ## If it's an unprotected route - just proceed
        if (all(!req$PATH_INFO %in% http_basic_auth$routes)) return(NULL);
        ## For protected routes - proceed handling the request if the token is set
        if (identical(req$HTTP_ACCESSTOKEN, http_basic_auth$token)) return(NULL);
        ## return an 401 error if the conditions are not satisfied
        list(
          status = 401L,
          headers = list(
            'Content-Type' = 'text/plain'
          ),
          body = paste('Access denied.')
        )
      }
    }
  httpuv_callbacks <- list(
    onHeaders = on_headers,
    call = http_server(routes),
    onWSOpen = function(ws) {
      # print('opening websocket')
    }
  )

  server_id <- httpuv::startServer("0.0.0.0", port, httpuv_callbacks)
  on.exit({ httpuv::stopServer(server_id) }, add = TRUE)

  repeat {
    httpuv::service(1)
    Sys.sleep(0.001)
  }
}
