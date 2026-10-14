<!--
{
  "title": "structKeyExists vs isNull vs ParameterExists vs isDefined vs elvis operator",
  "id": "null-checks-comparison",
  "description": "Verified comparison of structKeyExists(), isNull(), parameterExists(), isDefined(), the elvis operator and safe navigation for null values, missing keys and undefined variables, with and without full null support.",
  "keywords": [
    "structKeyExists",
    "isNull",
    "isDefined",
    "parameterExists",
    "elvis",
    "safe navigation",
    "null support",
    "nullValue"
  ],
  "categories": [
    "core",
    "decision"
  ],
  "related": [
    "null_support",
    "null-structs-and-arrays",
    "function-structkeyexists",
    "function-isnull",
    "function-isdefined",
    "function-parameterexists",
    "function-nullvalue",
    "operators"
  ]
}
-->

# structKeyExists vs isNull vs ParameterExists vs isDefined vs elvis operator

CFML has several ways to ask "is there a value here?". They give the same answer for an existing value, but they differ for a key or variable that holds `null`, and the answer can change with the [[null_support]] setting.

All results on this page were verified on Lucee 7.1.2.19 and 8.0.0.211 (both versions behave the same).

## Test cases

```luceescript
s = {};
s.k = nullValue();                              // key holding null
json = deserializeJSON( '{"k":null,"x":1}' );   // JSON null, same results as s.k
empty = { k: "" };                              // key with an empty string
variables.v = nullValue();                      // variable set to null
a = { x: 1 };                                   // a.b.c with b missing
```

Struct literals (`{ k: nullValue() }`, `[ k: nullValue() ]`) and assignments (`s.k = nullValue()`) behave the same.

## Partial null support (default)

| Case | `structKeyExists()` | `isNull()` | `parameterExists()` | `isDefined()` | `x ?: "default"` | `x?.y` | `x` |
|---|---|---|---|---|---|---|---|
| struct key holding null | false | true | false | false | `"default"` | null | error |
| missing struct key | false | true | false | false | `"default"` | null | error |
| struct key with `""` | true | false | true | true | `""` | `""` | `""` |
| undefined variable | false | true | false | false | `"default"` | – | error |
| `variables` / `local` variable set to null | false | true | false | false | `"default"` | – | error |
| nested `a.b.c`, `b` missing | false (`a`, `"b"`) | true | false | false | `"default"` | null | error |

With partial null support, a key holding null behaves like a missing key for every check, and reading it directly throws. The key is still stored in the struct, though: `structCount()` and `structKeyList()` include it, and `serializeJSON()` writes it as `null`.

```luceescript
s = deserializeJSON( '{"a":null,"b":1}' );
dump( structKeyExists( s, "a" ) );  // false
dump( isNull( s.a ) );              // true
dump( structCount( s ) );           // 2
dump( serializeJSON( s ) );         // {"a":null,"b":1}
```

## Full null support

| Case | `structKeyExists()` | `isNull()` | `parameterExists()` | `isDefined()` | `x ?: "default"` | `x?.y` | `x` |
|---|---|---|---|---|---|---|---|
| struct key holding null | **true** | true | false | **true** | `"default"` | null | null |
| missing struct key | false | true | false | false | `"default"` | null | error |
| struct key with `""` | true | false | true | true | `""` | `""` | `""` |
| undefined variable | false | true | false | false | `"default"` | – | error |
| `variables` / `local` variable set to null | **true** | true | false | **true** | `"default"` | – | null |
| nested `a.b.c`, `b` missing | false (`a`, `"b"`) | true | false | false | `"default"` | null | error |

With full null support, a key or variable holding null **exists**: `structKeyExists()` and `isDefined()` return true, and reading it returns null instead of throwing. `isNull()` is true either way.

Two things don't change with full null support:

- The elvis operator returns the default for null, so `s.k ?: "default"` is `"default"` whether `k` is missing or holds null.
- `parameterExists()` returns false for a null value.

For the `isDefined()` column above the name was passed as a literal string (`isDefined( "s.k" )`). With full null support, a name held in a variable (`name = "s.k"; isDefined( name )`) returned false for a null value in the same test, like `parameterExists()`.

## Elvis operator and safe navigation

The elvis operator `?:` returns the right-hand side when the left-hand side is null or doesn't exist, without throwing. Safe navigation `?.` stops at the first missing part of a path and returns null:

```luceescript
a = { x: 1 };
dump( a.b.c ?: "default" );  // "default"
dump( isNull( a?.b?.c ) );   // true
dump( a.b.c );               // error: key [B] doesn't exist
```

An empty string is a value, so `empty.k ?: "default"` returns `""`.

## Recommendations

- To get a value or a fallback, use the elvis operator: `name = form.name ?: "anonymous";`. It behaves the same in both null support modes.
- To read a nested value that may be missing, use safe navigation: `city = user?.address?.city;`.
- To check for "no value", use [[function-isnull]]: it's true for null, missing keys and undefined variables in both modes. Use a scoped reference (`isNull( local.result )`), see [[null_support]].
- To check whether a key exists, use [[function-structkeyexists]], and keep in mind that a key holding null only counts as existing with full null support.
- To tell "key holds null" apart from "key is missing", you need full null support (`structKeyExists()` true plus `isNull()` true).
- Avoid [[function-isdefined]] for null checks: its result depends on the null support mode and, with full null support, on whether the name is a literal string.
- [[function-parameterexists]] is a legacy function that calls `isDefined()` internally. Use `structKeyExists()`, `isNull()` or the elvis operator instead.
