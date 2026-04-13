**Input types:** Accepts a key pair struct (from [[function-generatekeypair]]), a PEM string, or a Java key object. If you pass a key pair with both public and private keys, the COSE output includes the private key material in key `-4`.

**Struct keys:** The returned struct uses string keys like `"1"`, `"-1"`, `"-2"` because CFML struct keys are always strings. [[function-cborencode]] converts these back to CBOR integer keys when encoding to wire format.

**Supported key types:** EC (P-256, P-384, P-521) and Ed25519. RSA keys are not supported in COSE format.

**Primary use case:** Generating test authenticator data for WebAuthn integration tests, or interoperating with systems that use COSE keys (CWT tokens, COSE_Sign1 messages).
