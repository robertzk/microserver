#' Returns HTML in a server.
#'
#' @param html_string character. A sring of HTML.
#' @examples
#' routes <- list("/index" = function(...) html("<b>bold!</b>"))
#' @export
html <- function(html_string) {
  microserver_response(html_string, headers = list("content-type" = "text/html"))
}


#' Parses an HTML page and returns it to the server.
#'
#' @param file character. The relative path of the file.
#' @examples
#' routes <- list("/index" = html_page("views/index.html"))
#' @export
html_page <- function(file) {
  force(file)
  function(...) {
    file <- tryCatch(readLines(file), error = function(e) { stop("Could not find ", file) })
    html(paste0(file, collapse = "\n"))
  }
}


#' Legacy fetch_asset code.
#' @param asset_path character. File path to the asset to be hosted.
#' @export
fetch_asset <- function(asset_path) {
  warning("`fetch_asset` is legacy code.  Please use `html_page` instead.")
  html_page(file.path("public", asset_path))()
}


#' Decode a URL
#' @param obj An object containing URL code to decode.
from_url <- function(obj) {
  unlist(lapply(strsplit(utils::URLdecode(chartr("+", " ", obj)), "="),
    function(vec) setNames(paste0(vec[-1], collapse = "="), vec[[1]])))
}
