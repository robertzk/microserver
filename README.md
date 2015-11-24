Microserver [![Build Status](https://img.shields.io/travis/robertzk/microserver.svg)](https://travis-ci.org/robertzk/microserver) [![Coverage Status](https://img.shields.io/coveralls/robertzk/microserver.svg)](https://coveralls.io/r/robertzk/microserver) ![Release Tag](https://img.shields.io/github/tag/robertzk/microserver.svg)
===========

Minimal R server mimicking [Ruby's Sinatra gem](http://www.sinatrarb.com/).

# Usage

#### Basic API

```r
# First of all you need to define the routes for which your app will be responding.
# There is no differentiation between GET, POST, PUT, etc. - all routes respond
# to all types of requests
routes <- list(
  # every route is a map between path and the function that should be called
  # on the request
  # Let's make a route with path 'hello' that returns 'world'
  '/hello' = function(...) 'world',
  # That simple!
  # Now let's make something more complicated
  # Let's make a route 'sum' that would sum all the inputs for a JSON payload
  # that looks like {"values": [1,2,3,-5.6,...]}
  # and let's make it work with POST requests (or, generally speaking)
  # for requests that have a JSON body
  '/sum'   = function(p, q) {
    if (length(p) == 0) 'must be a POST request' else sum(unlist(p$values))
  },
  # You can also submit a wildcard route that will be called
  # whenever someone queries a route that was not specified
  # in the configuration
  function(...) { "This is microserver demo" }
)
# And then you can just run the server using the routes that you've defined
microserver::run_server(routes, port = 8103)
```

Here are some examples of querying this server:
![GET root](http://puu.sh/kRx5x/d34cd39f72.png)

![GET hello](http://puu.sh/kRwd1/95382fcb8f.png)

Notice how error message gets returned as a response
![POST sum](http://puu.sh/kRwqo/454be5aa0c.png)

![GET sum](http://puu.sh/kRwT5/ba673c15cb.png)

I used [httpie](https://github.com/jkbrzt/httpie) to query this server but you can use any other tool that let's you send HTTP requests, like `curl` or [httr](https://github.com/hadley/httr).

#### Webpages

Microserver can also be used to serve webpages!

```R
routes <- list(
  "/hello" = function(...) html("<b>hello!</b>"),
  "/about" = html_page("about.html"),
  html_page("index.html")
)
microserver::run_server(routes, port = 8103)
```

In the example above, the `/hello` route serves generated HTML, the `/about` and default routes serves HTML from a file.

You can then browse http://localhost:8103 in your browser to see the index page, go to http://localhost:8103/about to see the about page, etc.


# Installation

This package is not yet available from CRAN (as of October 5, 2015).
To install the latest development builds directly from GitHub, run this instead:

```r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("robertzk/microserver")
```
