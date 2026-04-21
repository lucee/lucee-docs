---
title: MavenExists
id: function-mavenexists
related:
- function-mavenload
- function-maveninfo
- function-mavenexport
- function-mavenimport
categories:
- java
description: Checks whether a Maven artifact is already in Lucee's local maven cache — a cheap filesystem-only predicate with no network or tree walk.
---

Checks whether a Maven artifact is present in Lucee's local maven cache directory.

This is a cheap filesystem-only predicate — it does not contact any remote repository and does not resolve transitive dependencies. 

Useful as a quick check or audit, or before calling [[function-mavenload]] or [[function-maveninfo]] to avoid re-resolving an artifact that is already available locally.

Accepts either three separate arguments (groupId, artifactId, version) or a single gradle-style coordinate string (`"group:artifact"` or `"group:artifact:version"`). If the version is omitted, returns true when any version of the coord is cached locally.
