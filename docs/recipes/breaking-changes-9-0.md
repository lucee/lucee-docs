<!--
{
  "title": "Breaking Changes between Lucee 8.0 and 9.0",
  "id": "breaking-changes-8-0-to-9-0",
  "categories": ["breaking changes", "migration", "compat"],
  "description": "A guide to breaking changes introduced in Lucee between version 8.0 and 9.0",
  "keywords": ["breaking changes", "Lucee 8.0", "Lucee 9.0", "migration", "upgrade", "regex", "Perl Regex extension"],
  "related": [
    "regex-migration-lucee-9",
    "java-regex-engine",
    "extension-installation",
    "environment-variables-system-properties",
    "breaking-changes-7-1-to-8-0"
  ]
}
-->

# Breaking Changes between Lucee 8.0 and 9.0

This document outlines the breaking changes introduced when upgrading from Lucee 8.0 to Lucee 9.0. Lucee 9 is in development, so this page grows as changes land.

[9.0 Changelog](https://download.lucee.org/changelog/?version=9.0)

## Other Breaking Changes in Lucee Releases

- [[breaking-changes-6-2-to-7-0]]
- [[breaking-changes-7-0-to-7-1]]
- [[breaking-changes-7-1-to-8-0]]

## Regex: Java Is the Default Engine, Perl Moved to an Extension

[LDEV-6632](https://luceeserver.atlassian.net/browse/LDEV-6632)

- The default regex engine changed from `perl` (Apache ORO) to `java`.
- The `perl` engine (aliases `perl5`, `classic`, `oro`) is no longer part of the core. It is available with the [Perl Regex extension](https://github.com/lucee/extension-perlregex) (`org.lucee:perlregex-extension`).
- `perl` stays a valid setting. Without the extension, a regex call fails with "The regex engine [perl] is not available".
- `useJavaAsRegexEngine=false` means `perl`, so it needs the extension too.

Applications without a regex setting now run on `java` without an error, but some patterns give different results, for example POSIX classes like `[[:alpha:]]`, `\1` in replacements and `.` across newlines.

Lucee 8 logs a deprecation warning when an application uses `perl` ([LDEV-6660](https://luceeserver.atlassian.net/browse/LDEV-6660)), so check the `application` log of your Lucee 8 servers for `RegexDeprecation` before upgrading.

**What to do:** move your patterns to `java` (or `compat` to keep the Perl-style replacement syntax), or install the Perl Regex extension and set `this.regex.type="perl"`. All steps and the differences between the engines are in [[regex-migration-lucee-9]].
