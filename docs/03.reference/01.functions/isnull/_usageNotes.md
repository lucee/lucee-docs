Always use scoped variable references with `isNull()`.

When a null argument shares a name with an outer-scoped variable, `isNull()` can return the wrong result / unexpected due to scope cascading:

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

Use scoped references to reliably check for null:

```lucee
if ( isNull( arguments.name ) ) { ... }
if ( isNull( local.result ) ) { ... }
if ( isNull( variables.config ) ) { ... }
```

See [[recipe-null-support]] for more information on null handling in CFML.
