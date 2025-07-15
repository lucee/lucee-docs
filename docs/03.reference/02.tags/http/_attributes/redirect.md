Whether to automatically follow HTTP redirects (3xx status codes).

When **true** (default): Automatically follows up to 15 redirects.

When **false**: Stops at the first redirect response. Use `cfhttp.responseHeader.LOCATION` to see the redirect target.

If redirect limit is exceeded, behaves as if set to false.

If set to "Lax", filecontent for redirects for POST and DELETE requests will be returned, since **7.0.0.208**