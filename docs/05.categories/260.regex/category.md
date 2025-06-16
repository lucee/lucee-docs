---
title: Regex
id: category-regex
description: Regular Expression support in Lucee
---

By default, Lucee uses the older [Oro](https://jakarta.apache.org/oro/demo.html) Regex Engine, which is compatible with ACF.

Since [5.3.8.79](https://luceeserver.atlassian.net/browse/LDEV-2892), Lucee also supports using the more modern, compatible engine built into java.

You can switch engines using the following options in your [[tag-application]]

```
this.regex.engine = "java";  // default is "perl"
// or
this.useJavaAsRegexEngine = true;
```

To switch between Regex engines on the fly (`<cfapplication>` only affects the current thread / request )

```
<!--- do perl regex stuff --->
<cfapplication action=“update” regex=“java”>
<!--- do modern java regex stuff --->
<cfapplication action=“update” regex=“perl”>
<!--- back to cperl  regex stuff --->
```
