---
title: string.encodeForSQL()
id: method-string-encodeforsql
methodObject: string
methodName: encodeForSQL
related:
- function-encodeforsql
- object-string
categories:
- string
- ESAPI
- SQL
- query
---

Encodes the given string for safe output in a query to reduce the risk of SQL Injection attacks.

_This method is not recommended_ -

This function is no longer suppprted by the underlying ESAPI library since 2.7.0 due to security concerns.

The use of query parameters are strongly encouraged. See [[tag-queryparam]].
