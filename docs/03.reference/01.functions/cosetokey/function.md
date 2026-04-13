---
title: CoseToKey
id: function-cosetokey
related:
- function-keytocose
- function-cbordecode
- function-generatekeypair
- function-verifysignature
categories:
- crypto
---

Converts a COSE key into a usable Java security key. COSE (CBOR Object Signing and Encryption) is the key format used by WebAuthn/passkeys — when a user registers a passkey, the browser sends their public key in COSE format.

Accepts either a struct (e.g. from [[function-cbordecode]]) or raw CBOR bytes. Returns a key pair struct with `public` (and `private` if the COSE key includes private material). Supports EC (P-256, P-384, P-521) and Ed25519 keys.