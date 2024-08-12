---
title: createULID
id: function-createulid
description: Generates a ULID (Universally Unique Lexicographically Sortable Identifier)
related:
- function-createguid
- function-createuuid
---

Generates a ULID (Universally Unique Lexicographically Sortable Identifier), a 128-bit identifier where the first 48 bits are a timestamp representing milliseconds since the Unix Epoch (1970-01-01), ensuring temporal ordering. 

The remaining 80 bits are populated by a secure random number generator, contributing to the identifier's uniqueness. The output is a 26-character string in its canonical representation. 

This function can operate in three modes specified by the 'type' argument:

- `empty` for standard ULID generation
- `monotonic` to ensure sequential IDs even in rapid succession
-  and `hash` to generate a ULID based on hashed input values.

ULIDs are better for insert performance, as they don't create sparse B-Tree indexes like UUIDs, saving disk space
