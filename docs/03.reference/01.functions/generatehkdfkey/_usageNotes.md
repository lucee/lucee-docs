HKDF is for deriving cryptographic keys from existing key material (e.g. a Diffie-Hellman shared secret, a master key, or a high-entropy random value). **It is NOT suitable for password hashing** — use [[function-argon2hash]] or [[function-bcrypthash]] for passwords.

Use [[function-generatehkdfkey]] when you need a single derived key. If you need multiple keys from the same input (e.g. separate encryption and authentication keys), use the two-phase API ([[function-hkdfextract]] + [[function-hkdfexpand]]) which is more efficient than calling GenerateHKDFKey multiple times.

The `info` parameter provides context separation — different info strings produce different keys from the same input. Use descriptive strings like "encryption key" or "authentication key".
