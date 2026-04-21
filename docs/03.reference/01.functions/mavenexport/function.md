---
title: MavenExport
id: function-mavenexport
related:
- function-mavenload
- function-maveninfo
- function-mavenexists
- function-mavenimport
categories:
- java
- server
- devops
---

Walks Lucee's local maven cache directory and returns a pom.xml string listing every cached artifact as a `<dependency>` entry.

The emitted pom uses a synthetic self-identifier (`com.example.lucee:mvn-cache-export:0`) with `<packaging>pom</packaging>` — it is a manifest of what is cached, not a buildable project. 

Scope is not recorded on disk so no `<scope>` is emitted; classifier is derived from the jar filename when present (e.g. native libraries like `sqlite-jdbc-3.47.0.0-linux-x86_64.jar` are exported with `<classifier>linux-x86_64</classifier>`).

Pairs with [[function-mavenimport]] to snapshot and restore a cache state. Use `fileWrite( path, mavenExport() )` to persist the output.
