With Lucee 6.1, the underlying decoder was switched to use Apache Common Codec, which is stricter but more standards compliant.

Use the `strict=false` argument for the older behaviour, which strips out invalid encodings and doesn't throw an exception.
