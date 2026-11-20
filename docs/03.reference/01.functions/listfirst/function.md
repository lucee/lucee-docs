---
title: ListFirst
id: function-listfirst
related:
categories:
    - list
    - string
---

Gets the first element of a list.

**Breaking change in Lucee 9.0** ([LDEV-4596](https://luceeserver.atlassian.net/browse/LDEV-4596)): an empty delimiter no longer falls back to the default comma. Like `listToArray( list, "" )`, the string is split into single characters, so `listFirst( "dev,LAS,lucee", "" )` returns `d`. See [[breaking-changes-8-0-to-9-0]].
