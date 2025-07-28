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

## Changelogs

- [Release notes, guides, demos](https://dev.lucee.org/tag/lucee-62)
- [https://download.lucee.org/changelog/?version=6.2](https://download.lucee.org/changelog/?version=6.2)
- [New tags and functions](https://docs.lucee.org/reference/changelog.html)

## Other Breaking Changes in Lucee Releases

- [[breaking-changes-5-4-to-6-0]]
- [[breaking-changes-6-0-to-6-1]]
- [[breaking-changes-6-2-to-7-0]]

## Java Support

- Java 21 is recommended as it's a LTS release.
- Java 23 is supported
- Java 24-ea works, but there are some issues with date handling
- Java 11 is supported
- Java 8 is no longer supported

## Single Mode

Lucee 6.0 introduced Single Mode, Lucee 7.0 only supports single mode (multi-mode, i.e. web admins/contexts are removed)

[[single-vs-multi-mode]]

## Changing PreciseMath to be off by default

With Lucee 6, we introduced support for higher precision maths, by switching the underlying Java class from Double to BigInteger.

During the development of 6.2, which was heavily focussed on increasing Lucee's overall performance, it became apparent that the overhead of BigDecimal, both in terms of performance and memory usage was too simply high.

So, we decided to switch the default back to preciseMath=false, which really improved performance as this affects any use of numbers. For most Lucee applications, this change will have no functional affect.

Dynamically switching preciseMath on and off as required is recommended, rather than using it all the time.

As part of this change, we updated all our test cases to test switching dynamically during a request and identified a few problems which we addressed.

## Support for Jakarta Servlet

Lucee 6.2 adds support for Jakarta Servlets, but it still based on javax.

Therefore, the javax libraries are required for Lucee 6.2 to work when deployed on a Jakarta based Servlet engine like Tomcat 10+, Jetty 12, Undertow 2.3.0, etc and newer.

Our Official Lucee 6.2 Installers and Docker images bundle Tomcat 10+ and these required javax libaries.

If you are manually deploying Lucee 6.2 to a Jakarta based servlet engine, you need to add the following javax libaries to the classpath (lib directory), otherwise, Lucee will fail to deploy.

- [javax.servlet-api-4.0.1.jar](https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar) 
- [javax.servlet.jsp-api-2.3.3.jar](https://repo1.maven.org/maven2/javax/servlet/jsp/javax.servlet.jsp-api/2.3.3/javax.servlet.jsp-api-2.3.3.jar)
- [javax.el-api-3.0.0.jar](https://repo1.maven.org/maven2/javax/el/javax.el-api/3.0.0/javax.el-api-3.0.0.jar) 

Older Javax Servlet engines (i.e. Tomcat 9) are still supported for Lucee 6.2 as well, just make sure they are updated and still maintained.

Lucee 7 is Jakarta based and therefore requires a Jakarta based Servlet engine.

[LDEV-4910](https://luceeserver.atlassian.net/browse/LDEV-4910)

[Javax to Jakarta Namespace Ecosystem Progress](https://jakarta.ee/blogs/javax-jakartaee-namespace-ecosystem-progress/)

## Lucee 6.2 is up to 50% faster for some operations than Lucee 5.4

While not exactly what you might expect as a breaking change, we did find that all the improvements made with 6.2 managed to surface some other underlying bugs, simply because Lucee got faster.

You also may find some race conditions, etc within your own code / applications.

## Default Application.Log Level is ERROR

[https://luceeserver.atlassian.net/browse/LDEV-5366](https://luceeserver.atlassian.net/browse/LDEV-5366)

## pagePoolClear() causes non heap memory to increase

Use [[function-inspectTemplates]] instead.

[LDEV-5491](https://luceeserver.atlassian.net/browse/LDEV-5491)

## Cookies Expires are now in GMT, rather than UTC

More of a bug fix than a breaking change, Lucee now adheres to the spec correctly, since with 6.2.2, making Cloudflare happier

[LDEV-4314](https://luceeserver.atlassian.net/browse/LDEV-4314)

## REST cfc will only look for Application.cfc in same directory

Previous behaviour was deemed to be a bug.

Workaround, create an Application.cfc which extends the parent Application.cfc

[LDEV-5323](https://luceeserver.atlassian.net/browse/LDEV-5323)