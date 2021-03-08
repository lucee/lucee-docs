Access Control List (ACL) to use for new files. Can be a either a string (`"authenticated-read"`, `"private"`, `"public-read"`, or `"public-read-write"`), or
an array of structs where each struct represents a permission or grant.

Example:
```[{email="xxx@yyy.com", permission="full_control"}, {group="all", permission="read"}]```

  Defaults to the value specified in the application's `this.s3.acl`, which is `"public"` if unspecified.
