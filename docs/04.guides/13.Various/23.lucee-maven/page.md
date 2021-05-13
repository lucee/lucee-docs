---
title: Lucee with Maven
id: lucee-with-maven
---

You can add Lucee to your Maven pom.xml files via the following:

```lucee
<repositories>
	<repository>
		<id>cfmlprojects</id>
		<url>http://cfmlprojects.org/artifacts</url>
	</repository>
</repositories>
```

And the dependency via:

```lucee
<dependency>
	<groupId>org.getlucee</groupId>
	<artifactId>lucee</artifactId>
	<version>4.1.0.005</version>
</dependency>
```

Or the single Lucee jar artifactId is "lucee-jar". (The above has all the dependencies, with the exception of database drivers which are marked as "optional", thus not included by default.)

These are the versions available:

```lucee
http://cfmlprojects.org/artifacts/org/getlucee/lucee/
```
