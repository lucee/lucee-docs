---
title: JwksLoad
id: function-jwksload
related:
- function-jwktokey
- function-jwtverify
categories:
- crypto
---

Parses a JWKS (JSON Web Key Set) — a JSON document containing multiple public keys, commonly published by OAuth/OIDC providers like Auth0, Okta, and Google at their /.well-known/jwks.json endpoint.

Returns an array of JWK structs.