---
title: JwkToKey
id: function-jwktokey
related:
- function-keytojwk
- function-jwksload
categories:
- crypto
---

Converts a JWK (JSON Web Key) back into a usable key object for signing or verification.

Accepts a struct or JSON string. Typically used after loading keys from an OAuth/OIDC provider's JWKS endpoint.