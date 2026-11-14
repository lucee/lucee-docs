```luceescript
// HKDFExtract is the first phase of HKDF: it concentrates the entropy from the input
// into a pseudorandom key (PRK). Use this when you need to derive multiple keys
// from the same secret (more efficient than calling GenerateHKDFKey multiple times).

// Extract a pseudorandom key from a secret and salt
prk = HKDFExtract( "SHA256", "salt", "my-secret-input" );
// prk is a 32-byte binary value (matches the hash output size)

// Then use HKDFExpand to derive multiple keys from the same PRK
encKey = HKDFExpand( "SHA256", prk, "encryption key", 32 );
authKey = HKDFExpand( "SHA256", prk, "authentication key", 32 );
ivBytes = HKDFExpand( "SHA256", prk, "iv", 16 );

// This two-phase approach is equivalent to calling GenerateHKDFKey separately
// but more efficient when deriving multiple keys from the same input

// SHA384 produces a 48-byte PRK, SHA512 produces a 64-byte PRK
prk384 = HKDFExtract( "SHA384", "salt", "secret" ); // 48 bytes
prk512 = HKDFExtract( "SHA512", "salt", "secret" ); // 64 bytes
```
