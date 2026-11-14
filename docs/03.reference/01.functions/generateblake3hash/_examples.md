```luceescript
// Blake3 is the latest in the Blake family - faster than Blake2 and SHA-256
// Default output is 32 bytes (256-bit)
hash = GenerateBlake3Hash( "hello world" );

// Blake3 is an extendable-output function (XOF) - you can request any output length
// Shorter output is always a prefix of longer output
hash32 = GenerateBlake3Hash( "test", 32 );  // 32 bytes
hash64 = GenerateBlake3Hash( "test", 64 );  // 64 bytes - starts with hash32
hash128 = GenerateBlake3Hash( "test", 128 ); // 128 bytes

// Keyed mode for MAC (requires exactly 32-byte key)
key = "12345678901234567890123456789012"; // exactly 32 bytes
mac = GenerateBlake3Hash( "important data", 32, key );

// Key derivation mode: derive different keys from the same secret using context strings
// This is useful when you need separate keys for encryption and authentication
encKey = GenerateBlake3Hash( "master-secret", 32, "", "MyApp v1 encryption" );
authKey = GenerateBlake3Hash( "master-secret", 32, "", "MyApp v1 authentication" );
// encKey != authKey - different context strings produce different keys

// Binary input is also supported
binary = charsetDecode( "hello", "utf-8" );
hash = GenerateBlake3Hash( binary );
```
