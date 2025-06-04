
<!--
{
  "title": "Breaking Changes Between Lucee 5.4 and 6.0",
  "id": "breaking-changes-5-4-to-6-0",
  "categories": ["breaking changes", "migration","compat"],
  "description": "A guide to breaking changes introduced in Lucee between version 5.4 and 6.0",
  "keywords": ["breaking changes", "Lucee 5.4", "Lucee 6.0", "migration", "upgrade"]
}
-->

# Breaking Changes Between Lucee 5.4 and 6.0

This document outlines all the breaking changes which you should be aware with when upgrading from Lucee 5.4 to Lucee 6.0. 

The descision to make breaking changes are not made lightly, generally speaking, they are made to align Lucee with ACF where possible, address performance or edge cases which can lead to problems, and also to address potential security issues.

Please review all these changes when upgrading your applications to ensure they run smoothly and reliably.

When migrating, the Lucee team highly recommends going straight to the latest 6.2 release, via a fresh install, working thru the breaking changes documents for each release, as listed and linked below.

Users upgrading to Lucee 6.2, running on Tomcat 11 and Java 21, have reported really improved performance and vastly reduced memory usage, so enjoy!

## CFConfig.json

With Lucee 6, we switched from using XML config, `lucee-server.xml` for Lucee to adopting json config `.CFConfig.json`

Lucee 6 will automatically convert an XML config to JSON

[[config]]

## Single Mode

Lucee 6.0 introduces Single Mode, which is on by default.

Lucee 7.0 only supports single mode (multi-mode, i.e. web admins/contexts are removed)

[[single-vs-multi-mode]]

## Changelogs

- [https://download.lucee.org/changelog/?version=6.0](https://download.lucee.org/changelog/?version=6.0)
- [New tags and functions](https://docs.lucee.org/reference/changelog.html)

## Other Breaking Changes in Lucee Releases

- [[breaking-changes-5-4-to-6-0]]
- [[breaking-changes-6-0-to-6-1]]
- [[breaking-changes-6-1-to-6-2]]
- [[breaking-changes-6-2-to-7-0]]

## Extensions

Some of the older extensions have been unbundled from the default Lucee distribution.

These extension are still available, but just need to be manually installed.

- CFCHART
- Hibernate ORM
- Lucene Search (CFSEARCH)
- FORM
- AXIS Webservices
- AJAX
- EHCache (unbundled in Lucee 7)
- Argon2 support was moved to an extension in Lucee 6.1

### CFQUERYPARAM no longer autocasts empty values to null

Prior to Lucee 6, cfqueryparam would automatically case empty values to null.

With Lucee 6, we have changed this behaviour to match ACF, as this can introduce subtle bugs and is slight less performant.

This behaviour for VARCHAR values remains unchanged.

For compatibility, there is an environment variable `LUCEE_QUERY_ALLOWEMPTYASNULL=TRUE` which can be set to re-enable the older behavior.

[LDEV-4410](https://luceeserver.atlassian.net/browse/LDEV-4410)

### DateDiff arguments changed to match ACF

The order of the arguments for the member function [[method-datetime-diff]] was changed in Lucee 6 to match ACF

[LDEV-2044](https://luceeserver.atlassian.net/browse/LDEV-2044)

### Use JVM cacerts by default

Prior to Lucee 6, Lucee would bundle its own `cacerts` file, which caused problems over time as newer root certificates wouldn't be accepted.

There is an environment variable `LUCEE.USE.LUCEE.SSL.TRUSTSTORE=TRUE` which can be set to re-enable the older behavior.

Since this change, [[function-sslcertificateinstall]] no longer works

[LDEV-917](https://luceeserver.atlassian.net/browse/LDEV-917)

### Lucee dialect has been removed

The Lucee dialect was removed as it wasn't being unused and was no longer maintained.

Removing it reduced memory usage and increased performance.

[LDEV-4327](https://luceeserver.atlassian.net/browse/LDEV-4327)

### Automatic date parsing for mask "m d" removed.

This was removed as it produced false positives, you can still parse these dates by providing an explicit date mask.

[LDEV-4506](https://luceeserver.atlassian.net/browse/LDEV-4506)

### Session cookies default to being secure

With Lucee 6.1, the defaults for session cookies was changed to be `samesite=lax, httponly=true`

You can revert this change by setting custom values.

[LDEV-3448](https://luceeserver.atlassian.net/browse/LDEV-3448)

### Lucee mappings are now checked before the root filesystem

The previous behaviour lead to problems on Linux systems

To revert to the previous behaviour, use the environment variable `LUCEE_MAPPING_FIRST=FALSE`

[LDEV-1718](https://luceeserver.atlassian.net/browse/LDEV-1718)

### The '===' operator now checks for value and type

Prior to Lucee 6, the `===` operator only returned true when comparing the same object, this has been changed to match the expected behavior.

[LDEV-1282](https://luceeserver.atlassian.net/browse/LDEV-1282)

### Query.map() member function returns a new query.

Previously the `.query.map()` member function would modify the query, rather than returning a new query

[LDEV-556](https://luceeserver.atlassian.net/browse/LDEV-556)

### Empty sessions and client scopes are no longer persisted

For better performance and memory usage, an empty session or client scope is no longer saved.

To restore previous behaviour, use the environment variables `LUCEE_STORE_EMPTY=TRUE`

[LDEV-3340](https://luceeserver.atlassian.net/browse/LDEV-3340)

### Allow multi-character delimiters for ListAppend()

[[function-listappend]]

[LDEV-2024](https://luceeserver.atlassian.net/browse/LDEV-2024)

### FileUpload now supports strict and allowedExtensions arguments

For ACF compatibility, the function signature for [[function-fileupload]] was changed.

[LDEV-2414](https://luceeserver.atlassian.net/browse/LDEV-2414)

### FileGetMimeType() now throws on a missing or empty file

[[function-filegetmimetype]]

### ReplaceList() matches support includeEmptyFields

Lucee 6 now accepts the same arguments as ACF [[function-replacelist]]

[LDEV-2729](https://luceeserver.atlassian.net/browse/LDEV-2729)

### struct.delete() now returns the modified struct

[[method-struct-delete]]

[LDEV-2915](https://luceeserver.atlassian.net/browse/LDEV-2915)

### deserializeJSON() with an empty string throws an exception

This was changed to match ACF behaviour.

[[function-deserializeJSON]]

[LDEV-3413](https://luceeserver.atlassian.net/browse/LDEV-3413)

### cflocation addToken defaults to false

This was changed to match modern security expectation.

[LDEV-3437](https://luceeserver.atlassian.net/browse/LDEV-3437)

### DirectoryRename() should return the new path, not void

[[function-DirectoryRename]]

[LDEV-3453](https://luceeserver.atlassian.net/browse/LDEV-3453)

### Query.addRow() member function now returns the updated query

Previously it returned the number of rows, this was changed to match ACF

[[method-query-addrow]]

[LDEV-3581](https://luceeserver.atlassian.net/browse/LDEV-3581)

### QueryAddRow() treats struct of arrays different than Adobe

[[function-queryaddrow]]

[LDEV-3933](https://luceeserver.atlassian.net/browse/LDEV-3933)

### DollarFormat incorrect negative values on Java 11

This was changed for consistency in CFML, as the underlying Java functionality changes between versions

Lucee 7 adds an additional argument, `useBrackets` to control this behavior

[[function-dollarformat]]

[LDEV-3743](https://luceeserver.atlassian.net/browse/LDEV-3743)

### String member functions assume list instead of char array like Adobe

[LDEV-3747](https://luceeserver.atlassian.net/browse/LDEV-3747)

### Encrypt issue using Base64, invalid character [=] in base64 string at position

There is a new argument precise, which defaults to true, set to false if you encounter problems

- [[function-encrypt]]
- [[function-decrypt]]
- [[function-tobinary]]
- [[function-binarydecode]]

[LDEV-4101](https://luceeserver.atlassian.net/browse/LDEV-4101)

### CFFILE action=upload attemptedServerFile now returns the attempted filename

Previously, Lucee would incorrectly return the new file name

[[tag-file]]

[LDEV-4201](https://luceeserver.atlassian.net/browse/LDEV-4201)

### ArrayNew() typed argument changes

Changes were made to match ACF

[[function-arraynew]]

[LDEV-4271](https://luceeserver.atlassian.net/browse/LDEV-4271)

### FileWriteLine uses wrong line separator on Windows

Behaviour was changed to match ACF and use the operating system line separator (CFLF instead of LF)

[LDEV-4332](https://luceeserver.atlassian.net/browse/LDEV-4332)

### NumberFormat rounding decimal places differently

Number format now rounds up instead of down to match ACF behavior.

[[function-numberformat]]

[LDEV-4439](https://luceeserver.atlassian.net/browse/LDEV-4439)
