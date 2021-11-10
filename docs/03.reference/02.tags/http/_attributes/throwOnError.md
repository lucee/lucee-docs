Boolean indicating whether to throw an exception that can be caught by using the [[tag-try]] and [[tag-catch]] tags.

Errors include 

- a connection/response timeout
- a http response status code which isn't between 200 and 299
- a connection failure
- unable to resolve hostname (i.e. DNS)
- TLS/SSL problems

The default is NO.
