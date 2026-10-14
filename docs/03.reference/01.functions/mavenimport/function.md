---
title: MavenImport
id: function-mavenimport
related:
- function-mavenload
- function-maveninfo
- function-mavenexists
- function-mavenexport
categories:
- java
- server
- devops
description: Rehydrates Lucee's local maven cache from a pom.xml, resolving each listed dependency — the inverse of mavenExport for reproducible deploys.
---

Parses a pom.xml and resolves each declared `<dependency>` into Lucee's local maven cache, fetching any that are not already present.

By default only the literal dependencies listed in the pom are resolved — pairs symmetrically with [[function-mavenexport]], which writes the full cache contents as a flat list. 

Pass `includeTransitive=true` to also walk the dependency tree for each entry (same behaviour as [[function-mavenload]]).

Returns a query with the same shape as [[function-maveninfo]], showing what was resolved.
