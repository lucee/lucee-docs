<!--
{
  "title": "Java Regex Engine",
  "id": "java-regex-engine",
  "since": "5.3.8.79",
  "description": "How to switch from the legacy Apache ORO regex engine to Java's built-in regex engine for better performance and modern features.",
  "keywords": [
    "regex",
    "regular expressions",
    "Java regex",
    "Apache ORO",
    "performance",
    "Application.cfc",
    "REFind",
    "REReplace",
    "REMatch",
    "migration"
  ],
  "categories": [
    "regex"
  ],
  "related": [
    "recommended-settings",
    "function-refind",
    "function-rereplace",
    "function-rematch"
  ]
}
-->

# Java Regex Engine

How to switch Lucee from the legacy Apache ORO regex engine to Java's modern built-in regex engine.

## Background

By default, Lucee uses the [Apache ORO](https://jakarta.apache.org/oro/) regex engine (also known as "Perl" mode) for all regex functions (`REFind`, `REReplace`, `REMatch`, etc.). This keeps compatibility with Adobe ColdFusion and older code bases.

The problem is that Apache ORO was retired in 2010 and hasn't been maintained since. It lacks modern regex features like look-behinds and allocates new objects on every single regex call internally.

Since Lucee 5.3.8.79 ([LDEV-2892](https://luceeserver.atlassian.net/browse/LDEV-2892)), you can switch to Java's built-in `java.util.regex` engine, which is actively maintained, faster, and supports the full Java regex syntax.

## Enabling the Java Engine

Add one line to your `Application.cfc`:

```luceescript
component {
    this.regex = { engine: "java" };
}
```

Or use the ACF-compatible setting:

```luceescript
component {
    this.useJavaAsRegexEngine = true;
}
```

You can also switch engines on the fly within a request, using `<cfapplication>`:

```lucee
<!--- do perl regex stuff --->
<cfapplication action="update" regex="java">
<!--- do modern java regex stuff --->
<cfapplication action="update" regex="perl">
<!--- back to perl regex stuff --->
```

## Migration Gotchas

Switching engines is not a drop-in replacement. The Java regex engine has different syntax and behaviour in a few key areas. You will need to review and update your regex code.

### 1. DOTALL - `.` does not match newlines

In ORO, the `.` metacharacter matches newlines by default. In Java's regex engine, it does not.

If you have patterns that rely on `.` matching across lines, add the `(?s)` flag (DOTALL mode):

```luceescript
// ORO - works, dot matches newlines
splitterRegex = "^(\-\-\-\n(.*?)\n\-\-\-\n)?(.*)$";

// Java - need (?s) for dot to match newlines
splitterRegex = "(?s)^(\-\-\-\n(.*?)\n\-\-\-\n)?(.*)$";
```

### 2. Backreferences in replacements use `$` not `\`

This is the most common migration issue. ORO uses `\1`, `\2` etc. for group references in replacement strings. Java uses `$1`, `$2`.

```luceescript
// ORO
result = REReplace( content, "(foo)(bar)", "\1-\2" );

// Java
result = REReplace( content, "(foo)(bar)", "$1-$2" );
```

If you forget this, `\1` won't error - it will silently return the literal character `1` instead of the captured group. This can be tricky to debug.

### 3. Dollar signs in replacement strings become special

In ORO, `$` in a replacement string is just a literal dollar sign. In Java, `$` is the backreference prefix. Any replacement containing literal dollar signs (e.g. currency) will be misinterpreted:

```luceescript
// ORO - works fine, literal $
result = REReplace( price, "(\d+)", "Cost: $$$1" );

// Java - need to escape the literal dollar signs
result = REReplace( price, "(\d+)", "Cost: \$$$1" );
```

### 4. Case modification in replacements - ORO only

ORO supports Perl5-style case modification in replacement strings: `\u` (uppercase next char), `\l` (lowercase next char), `\U...\E` (uppercase block), `\L...\E` (lowercase block). Java has no equivalent. Code using these will silently produce wrong output with the Java engine.

```luceescript
// ORO - title-cases the match
result = REReplace( name, "(\w+)", "\u\1" );

// Java - no equivalent, use CFML string functions instead
```

### 5. POSIX character classes use different syntax

ORO uses the bracket-colon syntax from Perl: `[[:alpha:]]`, `[[:digit:]]`, `[[:punct:]]`. Java uses `\p{}` syntax instead, and the names are case-sensitive.

```luceescript
// ORO
result = REFind( "[[:alpha:]]+", input );

// Java
result = REFind( "\p{Alpha}+", input );
```

### 6. Curly braces are stricter in Java

Unescaped `{` and `}` outside a valid quantifier context will throw an error in Java. ORO is more lenient and treats them as literals.

```luceescript
// ORO - works, treats { as literal
result = REFind( "test{value}", input );

// Java - must escape the braces
result = REFind( "test\{value\}", input );
```

### 7. `.*` matches empty string at end of input

Java's `replaceAll` with `.*` will match the empty string at the end of input, producing an extra replacement. ORO does not. Use `.+` if you only want non-empty matches.

### 8. Line terminators

ORO treats only `\n` as a line terminator (consistent with Perl). Java recognises `\n`, `\r\n`, `\u0085` (NEL), `\u2028` and `\u2029` as line terminators. This affects `$` in MULTILINE mode and `.` in non-DOTALL mode.

### 9. Unicode support

ORO is limited to ASCII for character class operations. Java supports full Unicode character properties (`\p{Lu}`, `\p{IsLatin}`, etc.) and with the `UNICODE_CHARACTER_CLASS` flag, `\w`, `\d`, `\b` etc. become Unicode-aware.

## Java-Only Features

These features are only available with the Java engine and have no ORO equivalent:

- **Look-behinds:** `(?<=...)` and `(?<!...)`
- **Named capturing groups:** `(?<name>...)` with `${name}` backreferences
- **Possessive quantifiers:** `*+`, `++`, `?+` (no backtracking)
- **Atomic groups:** `(?>...)`
- **Inline flags:** `(?s)` DOTALL, `(?m)` MULTILINE, `(?i)` CASE_INSENSITIVE, `(?x)` COMMENTS

```luceescript
this.regex = { engine: "java" };

// Look-behind: match a number preceded by a dollar sign
result = REFind( "(?<=\$)\d+", "Price is $42" );

// Named group
result = REFind( "(?<year>\d{4})-(?<month>\d{2})", "2026-04-16", 1, true );
```

>>> HT to [Ben Nadel](https://www.bennadel.com/) whose extensive regex blog posts helped document many of these differences.

## Real-World Example: Migrating the Lucee Docs Build

While profiling the [Lucee documentation build](https://docs.lucee.org) using Java Flight Recorder (JFR), the allocation hotspot report showed hundreds of `org.apache.oro.text.regex.PatternMatcherInput`, `Perl5Matcher` and `Perl5Repetition` objects being created - one set per regex call across thousands of pages. Every `REReplace` or `REFind` call was allocating fresh objects internally, adding GC pressure for no reason.

After switching to the Java engine, the ORO allocations disappeared entirely and overall GC pressure dropped significantly:

| Metric | ORO (default) | Java engine |
| --- | --- | --- |
| ORO allocation samples | 52 | 0 |
| Total allocation samples | 8,604 | 6,390 |
| GC parallel phases | 244,344 | 66,050 |
| Build time | 58s | 52s |

The Lucee documentation build uses regex throughout its rendering pipeline, including parsing [[docs-markdown]] source files. Here are the actual changes needed to switch it to the Java engine:

**YAML frontmatter splitter** - needed both `(?s)` and `$` backreferences:

```luceescript
// Before (ORO)
var splitterRegex = "^(\-\-\-\n(.*?)\n\-\-\-\n)?(.*)$";
yaml = ReReplace( content, splitterRegex, "\2" );
body = ReReplace( content, splitterRegex, "\3" );

// After (Java)
var splitterRegex = "(?s)^(\-\-\-\n(.*?)\n\-\-\-\n)?(.*)$";
yaml = ReReplace( content, splitterRegex, "$2" );
body = ReReplace( content, splitterRegex, "$3" );
```

**Stripping markdown formatting** - backreference changes only:

```luceescript
// Before (ORO)
description = ReReplace( description, "\[\[([^\]]+)\]\]", "\1", "all" );
description = ReReplace( description, "\*\*([^\*]+)\*\*", "\1", "all" );

// After (Java)
description = ReReplace( description, "\[\[([^\]]+)\]\]", "$1", "all" );
description = ReReplace( description, "\*\*([^\*]+)\*\*", "$1", "all" );
```

**Simple patterns** - no changes needed:

```luceescript
// These work identically in both regex engines
ReReplace( content, "[\r\n]\s*([\r\n]|\Z)", Chr(10), "ALL" )
ReReplace( description, "\s\s+", " ", "all" )
reReplace( cleaned, "\r?\n", " ", "all" )
```
