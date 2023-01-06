For better performance, always use the `log` attribute with the name of a log which is either defined in the admin, or via [[tag-application]] `this.logs`

The `file` attribute is *deprecated* but still works, however, the file connection isn't cached, and will be slower than using a predefined `log`
