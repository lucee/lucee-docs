---
title: CborDecode
id: function-cbordecode
related:
- function-cborencode
- function-cbortojson
- function-cosetokey
categories:
- crypto
---

Decodes CBOR (Concise Binary Object Representation) binary data into native CFML types. CBOR is a binary data format similar to JSON but more compact and efficient — it's used by WebAuthn/passkeys, IoT protocols, and other systems where size and speed matter.

Returns the appropriate CFML type: struct, array, string, number, binary, or boolean.