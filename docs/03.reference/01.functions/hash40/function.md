---
title: Hash40
id: function-hash40
categories:
- crypto
related:
- function-hash
description: This function only exists for backward compatibility to Lucee 4.0
---

This function only exists for backward compatibility to Lucee 4.0 or older version that has produced an incorrect result for non us-ascii characters,
Only use this function for backward compatibility, use [[function-hash]] instead.

Converts a variable-length string to a 32-byte, hexadecimal string, using the MD5 algorithm.

(It is not possible to convert the hash result back to the source string.) 32-byte, hexadecimal string.
