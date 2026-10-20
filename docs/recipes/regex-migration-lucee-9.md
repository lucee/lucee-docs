<!--
{
  "title": "Regex Migration to Lucee 9",
  "id": "regex-migration-lucee-9",
  "since": "9.0",
  "description": "Lucee 9 uses the Java regex engine by default and moves the Perl5 (Apache ORO) engine into the Perl Regex extension. What changes, how to migrate your patterns, and how to stay on perl.",
  "keywords": [
    "regex",
    "regular expressions",
    "Lucee 9",
    "migration",
    "Apache ORO",
    "perl",
    "java",
    "compat",
    "regexType",
    "Perl Regex extension"
  ],
  "categories": [
    "regex",
    "migration",
    "breaking changes"
  ],
  "related": [
    "breaking-changes-8-0-to-9-0",
    "java-regex-engine",
    "tag-application",
    "environment-variables-system-properties",
    "extension-installation",
    "function-refind",
    "function-rereplace",
    "function-rematch"
  ]
}
-->

# Regex Migration to Lucee 9

Up to Lucee 8, the default engine for the regex functions (`REFind`, `REReplace`, `REMatch`, `REEscape`, the `NoCase` variants and every other place that uses a regex) is `perl`, the Perl5 engine of Apache ORO. ORO has not been maintained since 2010.

Lucee 9 changes two things ([LDEV-6632](https://luceeserver.atlassian.net/browse/LDEV-6632)):

1. **The default engine is now `java`** (`java.util.regex`).
2. **The `perl` engine is no longer part of the core.** It moved into the [Perl Regex extension](https://github.com/lucee/extension-perlregex).

Lucee 8 already logs a deprecation warning to the `application` log, once per application, when an application uses `perl` ([LDEV-6660](https://luceeserver.atlassian.net/browse/LDEV-6660)). Search your logs for `RegexDeprecation` to find the applications this change affects.

## The Engines

| Engine | Aliases | Lucee 8 | Lucee 9 |
| --- | --- | --- | --- |
| `java` | `modern` | built in | built in, **default** |
| `compat` | | built in | built in |
| `perl` | `perl5`, `classic`, `oro` | built in, default (deprecated) | **only with the Perl Regex extension** |

`compat` is the Java engine with the Perl-style replacement syntax: `\1` for a backreference and the case modifiers `\u \l \U \L \E`. It is the easiest step for code that mostly uses `REReplace`.

## What Happens on Upgrade

- **No regex setting:** your application now runs on `java`. There is no error. Patterns that behave differently (see below) just give different results.
- **`perl` set explicitly** (`this.regex.type="perl"`, `regexType` in `.CFConfig.json`, `this.useJavaAsRegexEngine=false`): the setting stays valid. If the Perl Regex extension is not installed, every regex call fails with "The regex engine [perl] is not available", naming the extension to install or the built-in engines to use instead.
- **`java` or `compat` set explicitly:** nothing changes.

## Choosing a Path

### Option 1: move to `java` (recommended)

Test your application on Lucee 8 with the Java engine before upgrading, then fix the patterns listed under [Differences](#differences-between-perl-and-java).

```luceescript
// Application.cfc
component {
    this.regex.type = "java";
}
```

### Option 2: move to `compat`

If most of your regex code is `REReplace` with `\1` backreferences or `\U`/`\L` case modifiers, `compat` keeps that replacement syntax while the patterns run on the Java engine.

```luceescript
this.regex.type = "compat";
```

### Option 3: stay on `perl`

1. Install the Perl Regex extension (Maven `org.lucee:perlregex-extension`), like any other extension, see [[extension-installation]]. For example in `.CFConfig.json`:

   ```json
   {
     "extensions": [
       { "maven": "org.lucee:perlregex-extension:<version>" }
     ]
   }
   ```

   Or with the environment variable `LUCEE_EXTENSIONS` (or the system property `lucee.extensions`):

   ```
   LUCEE_EXTENSIONS=org.lucee:perlregex-extension:<version>
   ```

   Replace `<version>` with the current release of the extension.

2. Select the engine, either per application or for the whole server:

   **Application.cfc**

   ```luceescript
   component {
       this.regex = { type: "perl" };
       // the legacy setting still works too: this.useJavaAsRegexEngine = false;
   }
   ```

   **Server, `.CFConfig.json`**

   ```json
   {
     "regexType": "perl"
   }
   ```

   **Server, system property or environment variable**

   ```
   -Dlucee.regex.type=perl
   LUCEE_REGEX_TYPE=perl
   ```

3. Check it:

   ```luceescript
   dump( getApplicationSettings().regex.type ); // perl
   ```

The extension is deprecated from the start. It exists to give existing applications time to move, so plan the move to `java` or `compat`.

## Differences between perl and java

These are the differences people hit most often. They are checked against Apache ORO 2.0.8 (with the options Lucee uses) and `java.util.regex`. The engine matrix tests in the Lucee repository (`test/general/regex`) show how all three engines behave for the same patterns.

### Silent differences (no error, different result)

| What | perl | java | What to do |
| --- | --- | --- | --- |
| POSIX classes `[[:alpha:]]`, `[[:digit:]]`, ... | POSIX class | a normal character class of the characters `: a l p h`, so `[[:alpha:]]+` on `123abc` matches only `a` | use `\p{Alpha}`, `\p{Digit}`, `\p{Punct}`, ... (case sensitive) |
| `.` and newlines | `.` matches a newline | `.` does not match a newline | add `(?s)` at the start of the pattern |
| Backreference in the replacement | `\1` | `$1` (`\1` gives a literal `1`) | use `$1`, or `compat` |
| `$` in the replacement | a literal `$` | a backreference, a literal `$` must be written `\$` | escape it, or `compat` |
| Case modifiers `\u \l \U \L \E` | supported | not supported, `\U$1\E` on `abc` gives `UabcE` | use `uCase()`, `lCase()` or a callback, or `compat` |
| `.*` with `REReplace(..., "all")` | one replacement | also matches the empty string at the end, `.*` on `abc` replaced by `X` gives `XX` | use `.+`, or anchor the pattern |
| Case-insensitive non-ASCII (`REFindNoCase`) | `Ä` matches `ä` | only ASCII is case-insensitive by default | add `(?iu)` to the pattern |
| Line terminators | only `\n` | also `\r\n`, `\u0085`, `\u2028`, `\u2029` | check `$` in multiline mode and `.` |

### Errors on java

| What | perl | java | What to do |
| --- | --- | --- | --- |
| Unescaped `{` `}` outside a quantifier, e.g. `test{value}` | literal | `PatternSyntaxException` | escape them: `test\{value\}` |

### Only on java

These fail to compile on `perl` and work on `java`:

- look-behind `(?<=...)`, `(?<!...)`
- named groups `(?<name>...)`, with `${name}` in the replacement
- possessive quantifiers `*+`, `++`, `?+` and atomic groups `(?>...)`
- Unicode properties `\p{L}`, `\p{IsLatin}`

More examples and the background are in [[java-regex-engine]].

## Finding Affected Code

Search your code base for:

- `[[:` (POSIX classes)
- `REReplace` / `REReplaceNoCase` calls whose replacement contains `\1`-`\9`, `$`, `\u`, `\l`, `\U`, `\L` or `\E`
- patterns with `.` that must cross lines (templates, multi-line text)
- unescaped `{` that is not a quantifier like `{2}` or `{1,3}`
- `useJavaAsRegexEngine`, `this.regex`, `regexType`, `<cfapplication regex=...>`

Then run your tests on Lucee 8 with `this.regex.type="java"` (or the server setting `LUCEE_REGEX_TYPE=java`) before you upgrade.
