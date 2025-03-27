<!--
{
  "title": "Breaking Changes Between Lucee 6.2 and 7.0",
  "id": "breaking-changes-6-2-to-7-0",
  "categories": ["breaking changes", "migration","compat"],
  "description": "A guide to breaking changes introduced in Lucee between version 6.2 and 7.0",
  "keywords": ["breaking changes", "Lucee 6.2", "Lucee 7.0", "migration", "upgrade"],
  "related": [
    "tag-application",
	"single-vs-multi-mode"
  ]
}
-->

# Breaking Changes between Lucee 6.2 and 7.0

This document outlines the breaking changes introduced when upgrading from Lucee 6.2 to Lucee 7.0.

Be aware of these changes when migrating your applications to ensure smooth compatibility.

## Java Support

- Java 21 is recommended as it's a LTS release.
- Java 23 is supported
- Java 24-ea works, but there are some issues with date handling
- Java 11 is supported
- Java 8 is no longer supported

## Switching to Jakarta (from Javax)

Lucee 6.2 introduced support for jakarta (Tomcat 10+) etc, but was still javax based

Lucee 7.0 is now based on [Jakarta](https://jakarta.ee/).

[LDEV-4910](https://luceeserver.atlassian.net/browse/LDEV-4910)

[Lucee/script-runner](https://github.com/lucee/script-runner/releases/tag/1.2) was updated to include [jakarta.jakartaee-api](https://github.com/lucee/script-runner/commit/0b2750cdbf0af746ba40ae74a0510eeaf4de6fd1)

[Javax to Jakarta Namespace Ecosystem Progress](https://jakarta.ee/blogs/javax-jakartaee-namespace-ecosystem-progress/)

## Single Mode Only

Lucee 7.0 only supports single mode [[single-vs-multi-mode]]

## Application.cfm / OnRequestEnd.cfm disabled by default

For performance reasons, by default Lucee 7 only looks for `Application.cfc`, you can still configure your server to look for `Application.cfm` if needed.

[[tag-application]]

[Defaulting to only looking for Application.cfc in Lucee 7](https://dev.lucee.org/t/defaulting-to-only-looking-for-application-cfc-in-lucee-7/14881)

## Properly Scope Internal Tag Variables in Lucee Functions

Prior to Lucee 7, tag results like `CFQUERY`, `CFLOCK`, `CFFILE`, `CFTHREAD` were written into the default variables scope.

With Lucee 7, when these tags are used within a function, these are now written to the local scope.

This should have minimal impact on existing code and may avoid some concurrency race conditions, hence the change.

[LDEV-5416](https://luceeserver.atlassian.net/browse/LDEV-5416)

## Enable Limit evaluation by default

Adopting secure defaults, Lucee 7 by default sets this to true

[LDEV-5177](https://luceeserver.atlassian.net/browse/LDEV-5177)

## Enabled correct encoding of spaces in urls with CFHTTP

Older versions of Lucee double encoded spaces in CFHTTP, causing problems calling some APIs

[LDEV-3349](https://luceeserver.atlassian.net/browse/LDEV-3349)

## Remove support for loginStorage="cookie" and sessionStorage="cookie"

These are insecure and seldom used

[LDEV-5403](https://luceeserver.atlassian.net/browse/LDEV-5403)

## Enable quoted-printable for CFMAIL by default

Fore better support for HTML emails, Lucee 7 defaults to 7 bit encoding

[LDEV-4039](https://luceeserver.atlassian.net/browse/LDEV-4039)

# Pending changes (not yet implemented)

All proposed changes are listed in the sprint board for 7.0 

[https://luceeserver.atlassian.net/jira/software/c/projects/LDEV/boards/53?label=breaking-change&sprint=73&sprints=73](https://luceeserver.atlassian.net/jira/software/c/projects/LDEV/boards/53?label=breaking-change&sprint=73&sprints=73)

Please raise any discussions regarding these changes on the dev forum, not in the individual tickets