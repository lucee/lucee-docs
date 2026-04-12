```luceescript
// Blake2s is optimised for 32-bit platforms (e.g. IoT, embedded systems)
// For general-purpose hashing on servers, prefer Blake2b or Blake3
// Default output is 32 bytes (256-bit)
hash = GenerateBlake2sHash( "hello world" );

// Deterministic - same input always gives same output
hash1 = GenerateBlake2sHash( "test data" );
hash2 = GenerateBlake2sHash( "test data" );
// hash1 == hash2

// Custom output length: Blake2s supports 1-32 bytes (smaller range than Blake2b)
shortHash = GenerateBlake2sHash( "test", 16 ); // 16 bytes = 32 hex chars
fullHash = GenerateBlake2sHash( "test", 32 );  // 32 bytes = 64 hex chars

// Keyed mode for MAC (message authentication code)
key = "mysecretkey123456789012345678901"; // up to 32 bytes
mac = GenerateBlake2sHash( "important data", 32, key );
```
