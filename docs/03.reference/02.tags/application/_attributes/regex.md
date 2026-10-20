A struct containing the configuration for regular expressions

The key "type" (or "engine") selects the regex engine:

- **perl** (aliases `perl5`, `classic`): Perl5 engine (Apache ORO). Default up to Lucee 8, **deprecated**: Lucee 9 uses `java` as default and `perl` is only available with the Perl Regex extension, see [[regex-migration-lucee-9]]
- **java** (alias `modern`): Java regex engine, default in Lucee 9
- **compat**: Java regex engine with the Perl-style replacement syntax (`\1`, `\u \l \U \L \E`)

i.e. `{type: "java"}`

``` this.useJavaAsRegexEngine = true; ``` also works
