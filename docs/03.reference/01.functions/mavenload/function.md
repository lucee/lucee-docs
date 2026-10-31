---
title: MavenLoad
id: function-mavenload
related:
- function-createobject
categories:
- java
---

Loads all JAR files from one or more Maven endpoints and makes them available for use within the Lucee server environment. 
This function can be used to load dependencies, including transitive ones, for example at server startup.
Like Maven, dependencies marked as optional are not loaded, unless `includeOptional` is set to true.

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
#### Skipping Transitive Dependencies (9.0+)

Each struct accepts two optional keys to limit what is loaded: `transitive` (set to `false` to load only that artifact, default `true`) and `exclusions` (an array of `groupId:artifactId` entries, `*` is a wildcard) to skip artifacts and the dependencies they bring in. See [[java-settings]] for details.

```cfml
mavenLoad([
{
"groupId": "org.apache.tika",
"artifactId": "tika-parsers-standard-package",
"version": "3.0.0",
"exclusions": [ "org.bouncycastle:*" ]
}
]);
```
