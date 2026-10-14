<!--
{
  "title": "Null Handling in CFML",
  "id": "null_support",
  "related": [
    "function-isnull",
    "function-nullvalue",
    "developing-with-lucee-server",
    "function-structkeyexists",
    "function-serializejson",
    "function-deserializejson",
    "tag-application",
    "null-structs-and-arrays"
  ],
  "description": "Understand the differences between partial and full null support - how it affects structKeyExists(), JSON serialization, queries and variable assignment.",
  "keywords": [
    "Null support",
    "null keyword",
    "NullValue function",
    "isNull function",
    "Lucee"
  ],
  "categories": [
    "core",
    "decision"
  ]
}
-->

# Null Support

CFML supports two null handling modes: partial (default) and full. This recipe explains the differences.

Video: [https://www.youtube.com/watch?v=GSlWfLR8Frs](https://www.youtube.com/watch?v=GSlWfLR8Frs)

## Enabling NULL Support

Via **Lucee Server Admin** > **Language/compiler** > **Null support**.

Or per application via [[tag-application]]:

```lucee
this.nullSupport = true;
```

Or toggle dynamically:

```lucee
application action="update" nullsupport="true";
```

## Function Return Values

```lucee
<cfscript>
    function test() {
    }
    dump( test() );

    t = test();
    dump(t);

    dump( isNull( t ) );
    dump( isNull( notexisting ) );
</cfscript>
```

A function with no return value returns `null`. With **partial support**, referencing `t` throws "the key [T] does not exist". With **full support**, `t` is accessible and `isNull(t)` returns `true`.

In both modes, `isNull(notexisting)` safely returns `true` for undefined variables.

## Query Column Values

```luceescript
query datasource="test" name="qry" {
    echo("select '' as empty, null as _null");
}
dump( qry );
dump( qry._null );
```

**Partial support**: `qry._null` outputs empty string.
**Full support**: outputs `Empty: null` and `isNull(qry._null)` returns `true`.

## [[function-nullvalue]] and the null Keyword

With **partial support**, use [[function-nullvalue]] to explicitly return null:

```luceescript
var possibleVariable = functionThatMayOrMayNotReturnNull();
return possibleVariable ?: NullValue();
```

With **full support**, use the `null` keyword directly:

```luceescript
t = null;
dump( t );
```

## StructKeyExists Behaviour

Key behavioural difference: how [[function-structkeyexists]] handles null values.

**Partial support** - null keys are reported as not existing, but they are still stored in the struct:

```luceescript
s = { foo: nullValue() };
dump( structKeyExists( s, "foo" ) ); // false
dump( s.keyExists( "foo" ) );        // false
dump( structCount( s ) );            // 1 - the key is still stored
dump( structKeyList( s ) );          // FOO
```

**Full support** - keys set to `null` still exist:

```luceescript
s = { foo: null };
dump( structKeyExists( s, "foo" ) ); // true
dump( s.keyExists( "foo" ) );        // true
dump( structCount( s ) );            // 1 - the key exists
dump( isNull( s.foo ) );             // true - but the value is null
```

This distinguishes "key exists with null value" from "key doesn't exist" - important for APIs and database results.

## JSON Serialization

In both modes, a key holding null is serialized as JSON `null`, so a JSON `null` survives a `deserializeJSON()` / `serializeJSON()` round trip.

**Partial support**:

```luceescript
s = { name: "John", middleName: nullValue() };
dump( serializeJSON( s ) ); // {"MIDDLENAME":null,"NAME":"John"}
dump( serializeJSON( deserializeJSON( '{"a":null,"b":1}' ) ) ); // {"a":null,"b":1}
```

**Full support**:

```luceescript
s = { name: "John", middleName: null };
dump( serializeJSON( s ) ); // {"MIDDLENAME":null,"NAME":"John"}
```

Critical for APIs that expect explicit `null` values rather than missing keys.

## Scoping and isNull()

Always use scoped variable references with [[function-isnull]].

When a variable with a `null` value shares a name with another variable in a scope accesssible via scope cascading, `isNull()` can return unexpected results:

```lucee
name = "default";

function greet( name ) {
    if ( isNull( name ) ) {
        writeOutput( "Hello stranger" );
    } else {
        writeOutput( "Hello #name#" );
    }
}

greet( javacast( "null", "" ) );
// Outputs: "Hello default" - found the outer variable, not the null argument!
```

Use scoped references to reliably check for `null`:

```lucee
if ( isNull( arguments.name ) ) { ... }
if ( isNull( local.result ) ) { ... }
if ( isNull( variables.config ) ) { ... }
```
