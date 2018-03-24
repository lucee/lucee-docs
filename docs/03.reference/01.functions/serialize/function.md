---
title: Serialize
id: function-serialize
related:
    - tips-serialize-data
    - function-deserializejson
    - function-serializejson
    - function-evaluate
categories:
---

Opposite of evaluate, this function serializes all cfml objects and all serializable Java objects. Can also serialize Components.

As objects can be serialized, this is not safe and cannot be trusted like JSON. 

Avoid using serialize/evaluate with untrusted end user content, serializeJSON / deserializeJSON is a safe alternative.


