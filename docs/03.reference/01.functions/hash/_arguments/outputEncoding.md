The format of the returned hash value (the digest). The following values are supported:

* hex: The digest as upper case hexadecimal string (default).
* base64: The digest as base64 string, including padding.
* base64url: The digest as URL safe base64 string, using `-` and `_` instead of `+` and `/`, without padding.

The value is not case sensitive. The algorithm QUICK only supports `hex`.

This argument is compatible with the argument of the same name in Adobe ColdFusion, where it is the 4th argument, in front of `numIterations` (called `iterations` there). Lucee keeps `numIterations` as the 4th argument, so existing code keeps working. If the 4th argument is not a number, it is used as `outputEncoding` and the 5th argument as `numIterations`. Using named arguments avoids any confusion.
