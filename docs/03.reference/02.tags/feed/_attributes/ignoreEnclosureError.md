If this attribute is true, Lucee attempts to save all enclosures.

If it encounters an error downloading one enclosure, it continues downloading other enclosures and writes the
error information in the server log.

If this attribute is false, Lucee stops downloading all enclosures and generates an error when it encounters
an error downloading an enclosure.

Note: Enclosure errors can occur if the specified enclosure is of a type that the web server does not allow to be
downloaded. (optional, default=false)
