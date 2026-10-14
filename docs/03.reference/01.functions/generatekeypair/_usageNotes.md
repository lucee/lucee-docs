**Which key type?**

- **P-256 (EC)** — Best default for most applications. Small keys, fast operations, widely supported. Use for JWT (ES256), TLS, and general-purpose signing.
- **RSA-2048** — Use when you need compatibility with older systems, Adobe ColdFusion, or SAML. Larger keys and slower than EC.
- **Ed25519** — Modern alternative to EC. Fastest signatures, smallest keys, but less ecosystem support than P-256. Only supports PKCS8 format (no traditional/OpenSSL format).
- **Kyber768** — Post-quantum key encapsulation. Use with [[function-kyberencapsulate]] for quantum-resistant key exchange.
- **Dilithium3** — Post-quantum signatures. Use with [[function-generatesignature]] for quantum-resistant signing.

**Output formats:**

- **PEM / PKCS8** (default) — Standard PEM with `-----BEGIN PRIVATE KEY-----` headers. Most compatible.
- **traditional / OPENSSL** — OpenSSL legacy format with algorithm-specific headers (e.g. `-----BEGIN RSA PRIVATE KEY-----`). Not available for Ed25519.
- **Base64** — Raw Base64-encoded key bytes without PEM headers.
- **DER** — Raw binary key bytes.
