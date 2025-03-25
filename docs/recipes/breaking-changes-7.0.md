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

[[LDEV-5416]](https://luceeserver.atlassian.net/browse/LDEV-5416)
