<!--
{
  "title": "Breaking Changes Between Lucee 6.1 and 6.2",
  "id": "breaking-changes-6-1-to-6-2",
  "categories": ["breaking changes", "migration","compat"],
  "description": "A guide to breaking changes introduced in Lucee between version 6.1 and 6.2",
  "keywords": ["breaking changes", "Lucee 6.1", "Lucee 6.2", "migration", "upgrade"],
  "related": [
    "mathematical-precision"
  ]
}
-->

# Breaking Changes between Lucee 6.1 and 6.2

This document outlines the breaking changes introduced when upgrading from Lucee 6.1 to Lucee 6.2. Be aware of these changes when migrating your applications to ensure smooth compatibility.

## Java Support

- Java 21 is recommended as it's a LTS release.
- Java 23 is supported
- Java 24-ea works, but there are some issues with date handling
- Java 11 is supported
- Java 8 is no longer supported

## Changing PreciseMath to be off by default

With Lucee 6, we introduced support for higher precision maths, by switching the underlying Java class from Double to BigInteger.

During the development of 6.2, which was heavily focussed on increasing Lucee's overall performance, it became apparent that the overhead of BigDecimal, both in terms of performance and memory usage was too simply high.

So, we decided to switch the default back to preciseMath=false, which really improved performance as this affects any use of numbers. For most Lucee applications, this change will have no functional affect.

Dynamically switching preciseMath on and off as required is recommended, rather than using it all the time.

As part of this change, we updated all our test cases to test switching dynamically during a request and identified a few problems which we addressed.

## Support for Jakarta Servlet

Lucee 6.2 adds support for Jakarta Servlet, in addition to Javax.

Javax libraries are still required for Lucee to work when deployed on a Jakarta based Servlet engine like Tomcat 10+.

Our Official Lucee 6.2 Installers and Docker images have been updated to bundle Tomcat 10+.

Older Javax Servlet engines (i.e. Tomcat 9) are still supported as well, just make sure they are updated and still maintained.

[LDEV-4910](https://luceeserver.atlassian.net/browse/LDEV-4910)

[Javax to Jakarta Namespace Ecosystem Progress](https://jakarta.ee/blogs/javax-jakartaee-namespace-ecosystem-progress/)

## Lucee 6.2 is up to 50% faster for some operations than Lucee 5.4

While not exactly what you might expect as a breaking change, we did find that all the improvements made with 6.2 managed to surface some other underlying bugs, simply because Lucee got faster.

You also may find some race conditions, etc within your own code / applications.

## Default Application.Log Level is ERROR

[https://luceeserver.atlassian.net/browse/LDEV-5366](https://luceeserver.atlassian.net/browse/LDEV-5366)
