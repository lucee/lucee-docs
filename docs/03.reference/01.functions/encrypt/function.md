---
title: Encrypt
id: function-encrypt
related:
- function-decrypt
categories:
- crypto
---

Encrypts a string. Uses a symmetric key-based algorithm, in
        which the same key is used to encrypt and decrypt a string.
        The security of the encrypted string depends on maintaining
        the secrecy of the key. Uses an XOR-based algorithm that uses
        a pseudo-random 32-bit key, based on a seed passed by the user
        as a function parameter.
