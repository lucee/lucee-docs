---
title: StructKeyExists
id: function-structkeyexists
related:
- function-sessionexists
categories:
- struct
---

Determines whether a specific key is present in a structure.
**Note:** When a struct's key contains a NULL as a value, Lucee's Null Support setting affects the outcome.
When Null Support is **false**, if a key DOES exist, and it has a NULL as a value, it will return **false**.
When Null Support is **true**, if a key DOES exist, and it has a NULL as a value, it will return **true**.
