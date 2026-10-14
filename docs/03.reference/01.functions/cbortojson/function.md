---
title: CborToJson
id: function-cbortojson
related:
- function-jsontocbor
- function-cbordecode
categories:
- crypto
---

Converts CBOR (Concise Binary Object Representation) binary data directly to a JSON string, without going through CFML types first. Useful when you receive CBOR from an external system and need to pass it on as JSON — for example, logging or forwarding WebAuthn attestation data to a JSON API.