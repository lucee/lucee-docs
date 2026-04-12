```luceescript
// HKDF (HMAC-based Key Derivation Function) derives strong key material from a secret
// Common use: turning a password or shared secret into one or more encryption keys

// One-shot key derivation: algorithm, input key material, salt, info, output length
key = GenerateHKDFKey( "SHA256", "my-secret", "random-salt", "encryption", 32 );
// key is a 32-byte binary value suitable for AES-256

// HKDF is deterministic - same inputs always produce the same key
key1 = GenerateHKDFKey( "SHA256", "secret", "salt", "info", 32 );
key2 = GenerateHKDFKey( "SHA256", "secret", "salt", "info", 32 );
// key1 == key2

// Use different "info" strings to derive multiple keys from the same secret
// This is how you'd create separate keys for different purposes
encKey = GenerateHKDFKey( "SHA256", "master-secret", "salt", "encryption", 32 );
authKey = GenerateHKDFKey( "SHA256", "master-secret", "salt", "authentication", 32 );
// encKey != authKey

// Supports SHA256, SHA384, and SHA512
key = GenerateHKDFKey( "SHA384", "secret", "salt", "info", 48 );
key = GenerateHKDFKey( "SHA512", "secret", "salt", "info", 64 );

// Salt and info can be empty strings (but providing them is recommended)
key = GenerateHKDFKey( "SHA256", "secret", "", "", 32 );

// Binary input is also accepted
ikm = charsetDecode( "secret", "utf-8" );
salt = charsetDecode( "salt", "utf-8" );
key = GenerateHKDFKey( "SHA256", ikm, salt, "info", 32 );
```
