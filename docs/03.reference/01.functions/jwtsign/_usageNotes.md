**Algorithm selection:** If you omit the `algorithm` parameter, it's auto-detected from the key type:

- RSA key → RS256
- P-256 → ES256, P-384 → ES384, P-521 → ES512
- Ed25519 → EdDSA

For HMAC (HS256/HS384/HS512), the algorithm must be specified explicitly since the key is just a string.

**Claims:** The `iat` (issued-at) claim is set automatically. If you set `exp` explicitly in your claims struct, it takes precedence over the `expiresIn` parameter.

**Key security:** For HMAC, your secret must be at least as long as the hash output (32 bytes for HS256, 48 for HS384, 64 for HS512). Short secrets are technically accepted but cryptographically weak.

For asymmetric algorithms (RS256, ES256, etc.), sign with the private key and verify with the public key using [[function-jwtverify]].
