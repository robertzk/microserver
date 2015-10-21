Microserver [![Build Status](https://img.shields.io/travis/robertzk/microserver.svg)](https://travis-ci.org/robertzk/microserver) [![Coverage Status](https://img.shields.io/coveralls/robertzk/microserver.svg)](https://coveralls.io/r/robertzk/microserver) ![Release Tag](https://img.shields.io/github/tag/robertzk/microserver.svg)
===========

Minimal R server mimicking Ruby's Sinatra gem.

# Installation

This package is not yet available from CRAN (as of October 5, 2015).
To install the latest development builds directly from GitHub, run this instead:

```r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("robertzk/microserver")
```

# Usage

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



## License

This project is licensed under the MIT License:

Copyright (c) 2015-2016 Robert Krzyzanowski

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


## Authors

This package was originally created by Robert Krzyzanowski. Additional
maintenance and improvement work was later done by Kirill Sevastyanenko.
