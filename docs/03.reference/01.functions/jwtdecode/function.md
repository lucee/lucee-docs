---
title: JwtDecode
id: function-jwtdecode
related:
- function-jwtsign
- function-jwtverify
categories:
- crypto
---

Reads the header and payload of a JSON Web Token (JWT) without verifying the signature.

Useful for inspecting tokens during debugging or for reading the key ID before verification.

WARNING: never trust decoded claims without calling JwtVerify() first.