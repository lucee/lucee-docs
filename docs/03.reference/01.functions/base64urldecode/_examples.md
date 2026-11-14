```luceescript
// Decode a Base64URL-encoded string back to its original form
// Returns binary by default
decoded = Base64UrlDecode( "SGVsbG8gV29ybGQ" );
// decoded is a binary value
str = charsetEncode( decoded, "UTF-8" ); // "Hello World"

// Pass a charset to get a string directly
decoded = Base64UrlDecode( "SGVsbG8gV29ybGQ", "UTF-8" );
// "Hello World"

// Handles missing padding automatically (Base64URL typically omits padding)
decoded = Base64UrlDecode( "dGVzdA", "UTF-8" ); // "test"
```
