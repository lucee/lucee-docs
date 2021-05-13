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

// booleans (always non-empty)
IsEmpty( false ) == false;
IsEmpty( true ) == false;
```

>>>> Prior to Lucee 4.5.1.016, `IsEmpty( 0 )` and `IsEmpty( false )` both returned true.
