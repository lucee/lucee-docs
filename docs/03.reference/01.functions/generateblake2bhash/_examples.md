```luceescript
// Blake2b is a fast, cryptographic hash function - great for checksums and integrity checks
// Default output is 32 bytes (256-bit), returned as a hex string
hash = GenerateBlake2bHash( "hello world" );
// hash is a 64-character hex string (32 bytes)

// Unlike password hashes, Blake2b is deterministic - same input always gives same output
hash1 = GenerateBlake2bHash( "test data" );
hash2 = GenerateBlake2bHash( "test data" );
// hash1 == hash2

// Custom output length: Blake2b supports 1-64 bytes
shortHash = GenerateBlake2bHash( "test", 16 ); // 16 bytes = 32 hex chars
longHash = GenerateBlake2bHash( "test", 64 );  // 64 bytes = 128 hex chars

// Keyed mode turns Blake2b into a MAC (message authentication code)
// Useful for verifying data integrity with a shared secret
key = "mysecretkey12345678901234567890ab"; // up to 64 bytes
mac = GenerateBlake2bHash( "important data", 32, key );

// Binary input is also supported
binary = charsetDecode( "hello", "utf-8" );
hash = GenerateBlake2bHash( binary );
```
