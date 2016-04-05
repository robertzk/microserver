# Version 0.1.2

* Fixed a bug for certain simplification of POST parameters.
  (e.g., `{"a":"b"}` would get parsed as `c(a = "b")` 
  instead of `list(a = "b")`.

# Version 0.1.1

* added identical matching before pattern matching in `determine_route`.
