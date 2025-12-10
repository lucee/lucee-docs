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
    "tag-application"
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

# Null Support in CFML

CFML supports two null handling modes: partial (default) and full. This recipe explains the behavioural differences and when to use each. 

It is an annotation of the video found here: [https://www.youtube.com/watch?v=GSlWfLR8Frs](https://www.youtube.com/watch?v=GSlWfLR8Frs)

## Enabling NULL support

You can enable null support via the **Lucee Server Admin** --> **Language/compiler** and setting Null support to **full support** or **partial support** (default).

Per Application via [[tag-application]]

```lucee
this.nullSupport = true;
```

Or toggle dynamically via [[tag-application]]

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

In this example, the function `test()` does not return a value. This, in effect, is the same as returning `null`. If you dump the result of the function (`dump( test() );`), you will see that the dump outputs `Empty: Null`.

If we assign the function result to a variable, i.e. `t = test();`, and reference the variable, i.e. `dump( t );` an error will be thrown when using **partial support** for null: "the key [T] does not exist". If we enable **full support**, you will be able to reference the variable without error, the dump output will be `Empty: Null` and `IsNull( t )` will evaluate `true`.

In both modes, `isNull( notexisting )` will return `true` for an undefined variable - the function is specifically designed to safely check for null/undefined values without throwing an error.

## Query Column Values

```luceescript
query datasource="test" name="qry" {
    echo("select '' as empty, null as _null");
}
dump( qry );
dump( qry._null );
```

With **partial support** for NULL enabled, `dump(qry._null);` will output an **empty string**.

With **full support**, `Empty: null` will be output and `IsNull( qry._null );` will evaluate `true`.

## [[function-nullvalue]] and the null keyword

With **partial support** for NULL, the [[function-nullvalue]] function must be used to explicitly return a null value (this will work in all scenarios). For example:

```luceescript
var possibleVariable = functionThatMayOrMayNotReturnNull();
return possibleVariable ?: NullValue();
```

With **full support**, you are able to use the `null` keyword directly and, as illustrated above, can assign it to a variable directly:

```luceescript
t = null;
dump( t );
```

## StructKeyExists Behaviour

One of the most significant behavioural differences between partial and full null support is how [[function-structkeyexists]] (and the member function `keyExists()`) handles keys with null values.

With **partial support**, when a struct key holds a null value, [[function-structkeyexists]] returns `false` because the key is effectively removed:

```luceescript
s = { foo: nullValue() };
dump( structKeyExists( s, "foo" ) ); // false
dump( s.keyExists( "foo" ) );        // false
dump( structCount( s ) );            // 0 - the key doesn't exist
```

This standard CFML behaviour can be surprising when you explicitly set a key to null but then can't detect its presence.

With **full support**, keys explicitly set to `null` still exist - they just hold a null value:

```luceescript
s = { foo: null };
dump( structKeyExists( s, "foo" ) ); // true
dump( s.keyExists( "foo" ) );        // true
dump( structCount( s ) );            // 1 - the key exists
dump( isNull( s.foo ) );             // true - but the value is null
```

This allows you to distinguish between "key exists with null value" and "key doesn't exist at all" - which is important when working with APIs, database results, or any scenario where the absence of a key has different meaning than a null value.

## JSON Serialization

With **partial support**, null values in structs are removed before serialization, so they don't appear in the JSON output:

```luceescript
s = { name: "John", middleName: nullValue() };
dump( serializeJSON( s ) ); // {"name":"John"} - middleName is missing
```

With **full support**, null values are properly serialized as JSON `null` via [[function-serializejson]]:

```luceescript
s = { name: "John", middleName: null };
dump( serializeJSON( s ) ); // {"name":"John","middleName":null}
```

This is critical when working with APIs that expect explicit `null` values rather than missing keys.
