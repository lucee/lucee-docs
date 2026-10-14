---
title: Queries / Database
menuTitle: Queries
id: category-query
description: Query, datasource and stored procedure functions and tags for working with relational databases in Lucee
categories:
- orm
---

Lucee provides first-class support for relational databases through the [[tag-query]] tag and the [[function-queryexecute]] function, with [[tag-queryparam]] and [[tag-transaction]] for safe parameterised SQL and transactional control.

Stored procedures are handled via [[tag-storedproc]], [[tag-procparam]] and [[tag-procresult]], and datasource metadata can be inspected with [[tag-dbinfo]].

Query results are returned as native query objects by default, or as an array of structs or a struct of arrays via the `returntype` attribute. They can be iterated, filtered, sorted and converted with the query manipulation functions in this category.

For object-relational mapping on top of these primitives, see the [[category-orm]] category.
