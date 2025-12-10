---
title: StructKeyExists
id: function-structkeyexists
related:
- function-sessionexists
- null_support
categories:
- struct
- decision
---

Determines whether a specific key is present in a structure.

In CFML, by default, this will return `false` for any keys with a `null` value, however, if Full Null Support is enabled, it will return `true`.

[[null_support]]