---
title: Lucee with Maven
id: lucee-with-maven
categories:
- java
---

<https://mvnrepository.com/artifact/org.lucee/lucee>

<https://search.maven.org/artifact/org.lucee/lucee>

You can add Lucee to your Maven pom.xml files via the following:

And the dependency via:

```lucee
<dependency>
  <groupId>org.lucee</groupId>
  <artifactId>lucee</artifactId>
  <version>5.3.8.206</version>
</dependency>
```

Or the single Lucee jar artifactId is "lucee-jar". (The above has all the dependencies, with the exception of database drivers which are marked as "optional", thus not included by default.)

