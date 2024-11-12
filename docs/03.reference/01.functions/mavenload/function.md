---
title: MavenLoad
id: function-mavenload
related:
- function-createobject
categories:
- classloading
- dependencies
- jars
- java
- maven
---

Loads all JAR files from one or more Maven endpoints and makes them available for use within the Lucee server environment. 
This function can be used to load dependencies, including transitive ones, for example at server startup.

### Example Usage of MavenLoad Function

The `MavenLoad` function allows you to load JAR files from Maven repositories, including all transitive dependencies. 
This is particularly useful during server startup to ensure that all required libraries are available.

#### Example Input as an Array of Structs:

```cfml
mavenLoad([
{
"groupId": "org.slf4j",
"artifactId": "slf4j-api",
"version": "1.7.32"
}
]);
```
