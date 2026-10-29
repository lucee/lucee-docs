<!--
{
  "title": "Catching multiple exception types",
  "id": "exception-multi-catch",
  "since": "9.0",
  "description": "Handle several exception types in a single catch, using a pipe to separate the types.",
  "keywords": [
    "exception",
    "error",
    "catch",
    "cfcatch",
    "multi-catch",
    "try"
  ],
  "categories": [
    "debugging"
  ],
  "related": [
    "tag-try",
    "tag-catch",
    "tag-throw",
    "exception-cause"
  ]
}
-->

# Catching multiple exception types

Lucee 9.0 allows a single `catch` to handle several exception types. Separate the types with a pipe (`|`), the catch body runs if the exception matches any of them. This matches the multi-catch syntax of Adobe ColdFusion 2025.

## Script

```run
<cfscript>
try {
    throw type="application" message="Upsi dupsi!";
}
catch ( database | application | expression e ) {
    dump( "caught a [#e.type#] exception: #e.message#" );
}
</cfscript>
```

## Tag

Each type has to be quoted:

```run
<cftry>
    <cfthrow type="application" message="Upsi dupsi!">
    <cfcatch type="database" | "application" | "expression" name="e">
        <cfdump var="caught a [#e.type#] exception: #e.message#">
    </cfcatch>
</cftry>
```

## Rules

- A variable name is required, `catch( a | b e )` or `<cfcatch type="a" | "b" name="e">`.
- The type `any` cannot be combined with other types, it already catches every exception. This is a compile error.
- An empty alternative, for example `a | | b`, is a compile error.
- The first catch that matches the exception is executed, if none matches the exception is passed on, same as with a single type.
