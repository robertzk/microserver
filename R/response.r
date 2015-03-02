#' Simple S3 class to denote JSON responses for httupv.
#'
#' @param response ANY. The R object to send as a response parameter.
#' If the header is set to text/json it will be converted into a JSON string.
#'
#' @param status integer. HTTP status (default is \code{200}).
#' @param headers list. A list of HTTP headers (default is
#'    \code{list('Content-Type' = 'text/json')}.
#' @importFrom jsonlite toJSON
#' @export
#' @examples
#' \dontrun{
#' response('Did not work!', 404) # 404 error
#' response(list(a = 1, b = 2))   # { "a": 1, "b": 2 } JSON response
#' }
microserver_response <- function(response = NULL, status = 200,
                     headers = list('content-type' = 'text/json')) {
  response <- tryCatch(
    list(body = ifelse(!is.null(response),
                       ifelse(headers$`content-type` == 'text/json',
                              to_json(response),
                              response),
                       ''),
         status = status, headers = headers),
    error = function(err) list(body = to_json(list(status = 'error',
      message = 'Error parsing JSON response')), status = 500,
      headers = list('content-type' = 'text/json')))
  class(response) <- 'microserver_response'
  response
}

#' Determine whether something is of S3 class microserver_response.
#'
#' @param obj any R object.
#' @return \code{TRUE} or \code{FALSE} if \code{obj} inherits \code{response}.
#' @seealso \code{\link{microserver_response}}
is.microserver_response <- function(obj) { inherits(obj, 'microserver_response') }
