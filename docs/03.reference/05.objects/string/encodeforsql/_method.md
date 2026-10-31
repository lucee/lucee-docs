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

**Deprecated:** this function is deprecated and not recommended. It still works, but escaping characters cannot protect a query as reliably as bound parameters do. Use query parameters instead, see [[tag-queryparam]] and the `params` argument of [[function-queryexecute]].

The underlying ESAPI library removed this function in version 2.7.0 due to security concerns. The Lucee ESAPI extension keeps its own implementation, so existing code is not affected, but new code should not use it.
