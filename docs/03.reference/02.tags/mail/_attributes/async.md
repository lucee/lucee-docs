if set to true, the mail is sent asynchronously by the Lucee Task manager (with multiple tries),
if set to false the mail is sent in the same thread that executes the request, which is useful for troubleshooting because you get an error message if there is one.

This setting overrides the setting with the same name in the Lucee Administrator.

This attribute replaces the old "spoolenable" attribute which is still supported as an alias.
