Default *true*, uses the Apache Commons UrlDecoder which has better overall support for UTF-8 etc, but throws an exception on invalid encodings.

When **false**, it will attempt strict mode first, then fall back to the older custom implementation which strips out invalid encodings, if strict fails.