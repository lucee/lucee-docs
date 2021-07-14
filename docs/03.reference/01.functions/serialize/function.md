---
title: Serialize
id: function-serialize
related:
- function-deserializejson
- function-evaluate
- function-serializejson
- tips-serialize-data
categories:
- java
---

Opposite of evaluate, this function serializes all cfml objects and all serializable Java objects. Can also serialize Components.

As objects can be serialized, this is not safe and cannot be trusted like JSON.

Avoid using serialize/evaluate with untrusted end user content, [[function-serializeJSON]] / [[function-deserializeJSON]] is a safe alternative.
