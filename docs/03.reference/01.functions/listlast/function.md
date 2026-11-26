---
title: ListLast
id: function-listlast
related:
categories:
    - list
    - string
---

Gets the last element of a list.

**Breaking change in Lucee 9.0** ([LDEV-4596](https://luceeserver.atlassian.net/browse/LDEV-4596)): an empty delimiter no longer falls back to the default comma. Like `listToArray( list, "" )`, the string is split into single characters, so `listLast( "dev,LAS,lucee", "" )` returns `e`. See [[breaking-changes-8-0-to-9-0]].
