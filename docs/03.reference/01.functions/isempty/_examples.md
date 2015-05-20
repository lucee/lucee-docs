The following statements all evaluate to true:

```lucee
// Strings
IsEmpty( '' ) == true;
IsEmpty( ' ' ) == false;
IsEmpty( '0' ) == false;

// arrays
IsEmpty( [] ) == true;
IsEmpty( [ 1, 2, 3 ] ) == false;

// structs
IsEmpty( {} ) == true;
IsEmpty( { key="value" } ) == false;

// queries
IsEmpty( QueryNew( 'column' ) ) == true;
IsEmpty( QueryNew( 'column', 'varchar', [ [ 'value' ] ] ) ) == false;

// numerics (always non-empty)
IsEmpty( 0 ) == false;
IsEmpty( 1 ) == false;
```

>>>> At the time of writing `IsEmpty( 0 );` returns `true`. This is unexpected behaviour and we advise not to use this function with numeric types.