#' Helper function for extracting a list of POST parameters from a request 
#' body (in JSON format for now).
#' 
#' @importFrom rjson fromJSON
#' @param request environment. The httpuv request environment.
extract_params_from_request <- function(request) {
  require(rjson)
  post_parameters <- request$rook.input$read_lines()
  if (nchar(post_parameters) == 0) NULL
  else tryCatch(fromJSON(post_parameters), error = function(err) err)
}

#' Helper function for extracting a list of GET parameters from a request 
#' body (in JSON format for now).
#' 
#' @param request environment. The httpuv request environment.
extract_query_from_request <- function(request) {
  require(rjson)
  require(utils)
  get_parameters <- strsplit(request$QUERY_STRING %||% '', '&')[[1]]
  Reduce(append, lapply(get_parameters, function(param) {
    param <- strsplit(param, "=")[[1]]
    param[[2]] <- utils::URLdecode(paste(param[-1], collapse = '='))
    setNames(list(param[[2]]), param[[1]])
  }))
}

