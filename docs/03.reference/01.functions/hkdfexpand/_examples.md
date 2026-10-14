```luceescript
// HKDFExpand is the second phase of HKDF: it expands a pseudorandom key (PRK)
// into one or more output keys. Use different "info" strings to derive separate keys.

// First, extract a PRK from your secret
prk = HKDFExtract( "SHA256", "salt", "master-secret" );

// Then expand into multiple keys for different purposes
encKey = HKDFExpand( "SHA256", prk, "encryption key", 32 );   // 32 bytes for AES-256
authKey = HKDFExpand( "SHA256", prk, "authentication key", 32 ); // 32 bytes for HMAC
ivBytes = HKDFExpand( "SHA256", prk, "iv", 16 );              // 16 bytes for AES IV

// Each key is different because the "info" string is different
// But they're all deterministically derived from the same master secret
```
