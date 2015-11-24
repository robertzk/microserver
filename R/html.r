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
