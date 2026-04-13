---
title: KeyToCose
id: function-keytocose
related:
- function-cosetokey
- function-cborencode
- function-generatekeypair
- function-keytojwk
categories:
- crypto
---

Converts a cryptographic key to COSE (CBOR Object Signing and Encryption) format — the key representation used by WebAuthn/passkeys and other CBOR-based protocols. Useful for generating test authenticator responses or interoperating with systems that expect COSE keys.

Accepts a key pair struct, PEM string, or Java key object. Supports EC (P-256, P-384, P-521) and Ed25519 keys.