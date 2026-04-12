The signature algorithm is auto-detected from the key type. For example, an RSA key uses SHA256withRSA, a P-256 key uses SHA256withECDSA, and an Ed25519 key uses EdDSA.

**Post-quantum signatures:** Dilithium signatures are significantly larger than classical signatures (approximately 2.4 KB for Dilithium3 vs 256 bytes for RSA-2048). Consider this if bandwidth or storage is a concern.

Digital signatures provide authentication (proof of who signed) and integrity (proof the data wasn't modified). They do not provide confidentiality — use encryption for that.
