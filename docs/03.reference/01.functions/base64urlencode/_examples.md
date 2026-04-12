```luceescript
// Base64URL encoding is a URL-safe variant of Base64 (used in JWTs, OAuth, etc.)
// It replaces + with -, / with _, and strips padding (=)
encoded = Base64UrlEncode( "Hello World" );
// "SGVsbG8gV29ybGQ" (no padding, no + or /)

// Unlike standard Base64, the output is safe to use in URLs and filenames
// Standard Base64: "Pj4/Pz8=" contains / and =
// Base64URL:       "Pj4_Pz8"  URL-safe, no padding

// Binary input is also supported
binary = charsetDecode( "test", "UTF-8" );
encoded = Base64UrlEncode( binary ); // "dGVzdA"

// Roundtrip with Base64UrlDecode
original = "The quick brown fox jumps over the lazy dog!";
encoded = Base64UrlEncode( original );
decoded = Base64UrlDecode( encoded, "UTF-8" );
// decoded == original
```
