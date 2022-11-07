A struct containing the configuration for regular expressions

ATM only the key "engine" is supported

Engines:

- **perl:** Use perl as regex engine
- **java:** Use java as regex engine

i.e. `{engine: "perl"}`

``` this.useJavaAsRegexEngine = true; ``` also works
