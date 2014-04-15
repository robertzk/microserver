\name{http_server}
\alias{http_server}
\title{Default http server configuration for libuv hook.}
\usage{
http_server(routes)
}
\arguments{
  \item{routes}{list. A named list of routes, with a
  handler function for each route. The first unnamed route
  will be used as the root. In none is provided, just a 404
  status will be returned.}
}
\description{
Default http server configuration for libuv hook.
}
\examples{
\dontrun{
  http_server(list('/ping' = function(params, query) 'Hello world!',
                   function(params, query) 'Invalid route.'))
}
}
\seealso{
\link{\code{parse_routes}}
}

