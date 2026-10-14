---
title: query.addColumn()
id: method-query-addcolumn
methodObject: query
methodName: addColumn
related:
- function-queryaddcolumn
- object-query
categories:
- query
---

Adds a column to a query and populates its rows with the contents of an one-dimensional array.

Pads query columns, if necessary, to ensure that all columns have the same number of rows.

For ACF compatibility, starting with version 6.0.0.207, the member function `query.addColumn()` returns the updated query (allowing method chaining). see [LDEV-3581](https://luceeserver.atlassian.net/browse/LDEV-3581)