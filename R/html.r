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


#' Parses an HTML page and returns it to the server.
#'
#' @param file character. The relative path of the file.
#' @examples
#' \dontrun{
#'    routes <- list("/index" = html_page("views/index.html")
#' }
#' @export
html_page <- function(file) {
  force(file)
  function(...) {
    file <- tryCatch(readLines(file), error = function(e) { stop("Could not find ", file) })
    html(paste0(file, collapse = "\n"))
  }
}


#' Decode a URL
from_url <- function(obj) {
  unlist(lapply(strsplit(utils::URLdecode(gsub("+", " ", obj, fixed = TRUE)), "="),
    function(vec) setNames(paste0(vec[-1], collapse = "="), vec[[1]])))
}
