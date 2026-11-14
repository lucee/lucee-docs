---
title: Cryptography
id: category-crypto
description: Encryption, hashing, digital signatures, key management, JWTs, CBOR, and more.
---

Lucee core provides basic cryptographic functions like `Encrypt()`, `Decrypt()`, `Hash()`, and `GenerateSecretKey()`.

For everything else — key pair generation, digital signatures, JWTs, password hashing (bcrypt, scrypt, Argon2), TOTP/HOTP, CBOR, COSE, post-quantum cryptography, and more — install the [Cryptography Extension](https://github.com/lucee/extension-crypto) for Lucee 7.0.3+.

It builds on [Bouncy Castle](https://www.bouncycastle.org/) to provide a comprehensive set of cryptographic functions without needing to drop into Java.
