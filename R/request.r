#' Helper function for extracting a list of POST parameters from a request 
#' body (in JSON format for now).
#' 
#' @importFrom jsonlite fromJSON
#' @param request environment. The httpuv request environment.
#' @return a list with the processed POST parameters.
extract_params_from_request <- function(request) {
  post_parameters <- request$rook.input$read_lines()
  if (length(post_parameters) == 0 || nchar(post_parameters) == 0) NULL
  else tryCatch(from_json(post_parameters, simplifyVector = FALSE),
                error = function(err) err)
}

#' Helper function for extracting a list of GET parameters from a request 
#' body (in JSON format for now).
#' 
#' @param request environment. The httpuv request environment.
#' @return a list with the processed GET parameters.
extract_query_from_request <- function(request) {
  get_parameters <- strsplit(gsub('^\\?', '', request$QUERY_STRING %||% ''), '&')[[1]]
  Reduce(append, lapply(get_parameters, function(param) {
    param <- strsplit(param, "=")[[1]]
    param[[2]] <- utils::URLdecode(paste(param[-1], collapse = '='))
    setNames(list(param[[2]]), param[[1]])
  }))
}

