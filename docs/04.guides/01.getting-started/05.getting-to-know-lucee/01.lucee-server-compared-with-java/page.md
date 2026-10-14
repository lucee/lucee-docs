---
title: Lucee server compared with Java
id: lucee-server-compared-with-java
---

## JVM ##

Like Java, Lucee Server is a JVM (Java Virtual Machine) based language — source code is compiled to Java bytecode and executed on the JVM. Unlike other JVM languages, Lucee Server comes with its own powerful runtime environment — it's not just a different syntax for Java bytecode, like Groovy.

## Structure ##

Various Java techniques have parallels with Lucee Server & CFML.

* Servlets and POJOs written in Java are comparable to CFCs.

* JSPs are comparable to CFMs.

* Various EJB services are available in Lucee Server, e.g. persistence, event-driven programming, scheduling, security

## Server ##

* Changes to Lucee Server are made with the Lucee Server administrator. In Java projects, comparable changes, especially relating to injectable resources, are often made in the Java container in use.

## Pros & cons ##

### Pros of Lucee ###

* CFML enables very fast prototyping

* CFML typically allows for faster development

* CFML does not have strong typing, which some developers may prefer

* CFML uses a fraction of the amount of code lines Java does

* CFML simplifies coding by abstracting away many details from developers

* Tight Java interop — call Java classes and methods directly, pass CFML values as arguments, catch Java exceptions. See [[java-class-interaction]] and [[java-in-functions-and-closures]].

* Use any Java library via Maven dependency resolution — no manual JAR juggling. See [[maven]] and [[java-libraries]].

* Implement Java interfaces from CFCs via dynamic proxies — pass a Lucee component wherever Java expects an interface instance. See [[dynamic-proxy-enhancements]].

* Embed Lucee in your own Java application via the Loader API. See [[loader-api-changes-7]].

* Cross-version servlet API support (`javax` ↔ `jakarta`) handled transparently. See [[javax-vs-jakarta]].

* No external libraries required for datasources, S3, zipping and many other functions

* Because Lucee Server can be deployed onto any servlet container, clients may be more likely to accept Lucee Server than a non-Java product

* Training staff to use Lucee Server will take a lot less time than Java

* IDEs and editors can be much simpler

* No need to build as this is done when the code is run for the first time.

### Cons of Lucee ###

* CFML does not have strong typing, whereas developers may prefer Java's strong typing

* Clients may be resistant to change to Lucee Server

* Lucee Server & CFML do not enforce practices whereas Java does

* CFML may not be as flexible as Java because options are abstracted away

* IDEs and editors are not as fully featured as Java environments.