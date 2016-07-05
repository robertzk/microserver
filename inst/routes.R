list(
    "/ping"        = function(...) "pong"
  , "/parse_query" = function(p, q) { list(query = q) }
  , function(...) list(exception = "catch all route")
)
