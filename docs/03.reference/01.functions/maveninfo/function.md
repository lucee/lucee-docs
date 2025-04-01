---
title: MavenInfo
id: function-maveninfo
related:
- function-mavenload
categories:
- maven
- classloading
- dependencies
- java
- server
---

Retrieves information about a Maven artifact and its dependencies.

This function allows you to query details about a specific Maven artifact by providing its coordinates (groupId, artifactId, and optionally version).

It returns a query containing information about the artifact itself and all of its dependencies based on the specified scope.

The returned query includes columns for:

- **groupId**: The group identifier of the artifact
- **artifactId**: The artifact identifier
- **version**: The version of the artifact
- **scope**: The scope of the dependency (compile, provided, runtime, test, system)
- **optional**: Whether the dependency is optional
- **checksum**: Checksum information
- **url**: URL where the artifact can be found
- **path**: Local file path to the artifact

This function is useful for debugging classloading issues, understanding dependency trees, or gathering information about the libraries your application depends on.