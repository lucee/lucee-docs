---
title: Embedding Lucee in Java Applications
id: lucee-with-maven
categories:
- java
description: How to embed Lucee as a dependency in your Java projects using Maven
---

Lucee is published to Maven Central, making it easy to embed the CFML engine directly into your Java applications. This is useful when you want to:

- Execute CFML templates from within a Java application
- Build custom tooling that needs to parse or analyse CFML code
- Create hybrid applications that leverage both Java and CFML
- Develop and test Lucee extensions

## Maven Coordinates

Lucee artifacts are available on Maven Central:

- <https://mvnrepository.com/artifact/org.lucee/lucee>
- <https://search.maven.org/artifact/org.lucee/lucee>

## Adding Lucee to Your Project

Add the following dependency to your `pom.xml`:

```xml
<dependency>
  <groupId>org.lucee</groupId>
  <artifactId>lucee</artifactId>
  <version>7.0.0.395</version>
</dependency>
```

This pulls in Lucee with all its dependencies, except database drivers which are marked as optional.

### Minimal JAR

If you only need the core Lucee classes without transitive dependencies, use the `lucee-jar` artifact instead:

```xml
<dependency>
  <groupId>org.lucee</groupId>
  <artifactId>lucee-jar</artifactId>
  <version>7.0.0.395</version>
</dependency>
```

## Related

If you're a CFML developer looking to load Java libraries into your Lucee application at runtime, see the [Maven recipe](../../recipes/maven.md) which covers the `this.javasettings` approach introduced in Lucee 6.2.
