<!--
{
  "title": "Breaking Changes between Lucee 6.2 and 7.0",
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

[[lucee_7_overview]]

[7.0 Changelog](https://download.lucee.org/changelog/?version=7.0)

[New Functions and Tags](https://docs.lucee.org/reference/changelog.html)

## Other Breaking Changes in Lucee Releases

- [[breaking-changes-5-4-to-6-0]]
- [[breaking-changes-6-0-to-6-1]]
- [[breaking-changes-6-1-to-6-2]]

## Java Support

- Java 24 for best performance!
- Java 21
- Java 11 is supported, but it's slower and support will be removed in the near future. Tomcat 11 requires Java 17
- **Java 8 is no longer supported**

## Switching to Jakarta (from Javax)

Lucee 6.2 introduced support for jakarta (Tomcat 10+) etc, but was still javax based

Lucee 7.0 is now based on [Jakarta](https://jakarta.ee/). As such, Tomcat 9.0 (or older) is no longer supported, we recommend doing a fresh install.

[LDEV-4910](https://luceeserver.atlassian.net/browse/LDEV-4910)

[Lucee/script-runner](https://github.com/lucee/script-runner/releases/tag/1.2) was updated to include [jakarta.jakartaee-api](https://github.com/lucee/script-runner/commit/0b2750cdbf0af746ba40ae74a0510eeaf4de6fd1)

[Javax to Jakarta Namespace Ecosystem Progress](https://jakarta.ee/blogs/javax-jakartaee-namespace-ecosystem-progress/)

### Common Migration Issues and Solutions

When upgrading to Lucee 7.0, you may encounter errors related to missing javax or jakarta classes. Lucee 7 provides clear, actionable error messages to help you resolve these issues quickly.

#### Scenario 1: Running Lucee 7 on Jakarta Containers (Tomcat 10+) with Old Extensions

**Symptom:** You see errors like:

```
java.lang.ClassNotFoundException: javax.servlet.jsp.tagext.TryCatchFinally not found by redis.extension
```

**Cause:** Extensions (Redis, Lucene, etc.) that were compiled against javax.servlet APIs are not compatible with Jakarta-based containers.

**Solution:** Update your extensions to Jakarta-compatible versions. Check the Lucee extension marketplace or your extension provider for updated versions that support Jakarta EE.

#### Scenario 2: Running Lucee 7 on Javax Containers (Tomcat 9 or earlier)

**Symptom:** You see errors about missing jakarta classes:

```
java.lang.NoClassDefFoundError: jakarta/servlet/http/HttpServletRequest
```

**Cause:** Lucee 7 requires Jakarta EE servlet APIs, which are not present in javax-based containers like Tomcat 9.

**Recommended Solution:** Upgrade to a Jakarta-based servlet container:

- Tomcat 10.1+ (recommended)
- Jetty 11+
- Other Jakarta EE 9+ compatible containers

**Temporary Workaround:** If you cannot immediately upgrade your servlet container, you can add Jakarta servlet APIs to your classpath:

- Maven dependency: [jakarta.servlet-api on Maven Central](https://mvnrepository.com/artifact/jakarta.servlet/jakarta.servlet-api)
- Download the JAR and add it to your servlet container's `lib` directory

Note: Adding Jakarta APIs is only a temporary solution. Upgrading to a Jakarta-based container is the proper long-term approach.

## Loader Change

Lucee 7.0 we have changed the Loader API, so that in place upgrades via the admin aren't supported OOTB.

The Loader Jar is found in the `lucee/lib` directory, i.e. `lucee-6.2.0.321.jar`.

To upgrade to Lucee 7.0 (if you are already running Tomcat 10.1), you will need to 

- Stop Lucee
- Replace that jar with a 7.0 version (`lucee.jar`) from [https://download.lucee.org/](https://download.lucee.org/)
- Restart Lucee.

The latest 5.4 and 6.2 releases will automatically ignore any attempts to do an in place upgrade, if the Loader jar is unsupported.

If you try upgrading an older release without these loader version checks, you will get a 500 error on startup. 

To get your Lucee instance back up and running if you experience this problem, stop Lucee and delete any lucee 7 `.lco` files from `lucee/tomcat/lucee-server/patches` and restart.

## Single Mode Only

Lucee 7.0 only supports Single Mode, which was introduced with Lucee 6.0.

[[single-vs-multi-mode]]

## Properly Scope Internal Tag Variables in Lucee Functions

Prior to Lucee 7, tag results like `CFQUERY`, `CFLOCK`, `CFFILE`, `CFTHREAD` were written into the default variables scope.

With Lucee 7, when these tags are used within a function, these are now written to the local scope.

This should have minimal impact on existing code and may avoid some concurrency race conditions, hence the change.

**Restore old behavior (if needed):** [[content::sysprop-envvar#LUCEE_TAG_POPULATE_LOCALSCOPE]]

[LDEV-5416](https://luceeserver.atlassian.net/browse/LDEV-5416)

## Enabled correct encoding of spaces in urls with CFHTTP

Older versions of Lucee double encoded spaces in CFHTTP, causing problems calling some APIs

[LDEV-3349](https://luceeserver.atlassian.net/browse/LDEV-3349)

## Remove support for loginStorage="cookie" and sessionStorage="cookie"

These are insecure and seldom used

[LDEV-5403](https://luceeserver.atlassian.net/browse/LDEV-5403)

## Enable quoted-printable for CFMAIL by default

For better HTML email support, Lucee 7 defaults to 7-bit encoding

[[content::sysprop-envvar#LUCEE_MAIL_USE_7BIT_TRANSFER_ENCODING_FOR_HTML_PARTS]]

[LDEV-4039](https://luceeserver.atlassian.net/browse/LDEV-4039)

## EHCache is no longer bundled

Still available as an extension, it is just no longer bundled in the default distribution.

This reduced the size of the full `lucee.jar` from 84 Mb to 64 Mb.

[LDEV-5267](https://luceeserver.atlassian.net/browse/LDEV-5267)

LDEV-5485

## Enable LUCEE_COMPILER_BLOCK_BYTECODE by default

Prevents cfml files containing java bytecode from being executed

[[content::sysprop-envvar#LUCEE_COMPILER_BLOCK_BYTECODE]]

[LDEV-5485](https://luceeserver.atlassian.net/browse/LDEV-5485)
[Lucee CVE-2024-55354](https://dev.lucee.org/t/lucee-cve-2024-55354-security-advisory-april-2025/14963)

## CFCACHE now defaults to ignoring query_string

Prior to Lucee 7, Lucee would include the query string in the cache key. Changed to match ACF behaviour since CF9.

The attribute, `useQueryString=boolean` was added as part of this change

[LDEV-5722](https://luceeserver.atlassian.net/browse/LDEV-5722)

## CFIMAP stopOnError added

Default is true, previously was effectively false

[LDEV-5764](https://luceeserver.atlassian.net/browse/LDEV-5764)

# Pending changes (not yet implemented)

All proposed changes are listed in the sprint board for 7.0

[https://luceeserver.atlassian.net/jira/software/c/projects/LDEV/boards/53?label=breaking-change&sprint=73&sprints=73](https://luceeserver.atlassian.net/jira/software/c/projects/LDEV/boards/53?label=breaking-change&sprint=73&sprints=73)

Please raise any discussions regarding these changes on the dev forum, not in the individual tickets