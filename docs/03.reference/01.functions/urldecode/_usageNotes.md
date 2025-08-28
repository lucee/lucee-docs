With Lucee 6.1, the underlying decoder was switched to use Apache Common Codec, which is stricter but more standards compliant.

Use the `strict=false` argument for the older behaviour, which strips out invalid encodings and doesn't throw an exception.

By default, Lucee attempts to decode all values passed in the `url` and `form` scopes, using strict mode. If an decoding error occurs, Lucee passes the raw value thru.
