```lucee
WriteOutput( IsEmpty( '' ) ); // true
WriteOutput( IsEmpty( ' ' ) ); // false
WriteOutput( IsEmpty( 'string' ) ); // false
WriteOutput( IsEmpty( [] ) ); // true
WriteOutput( IsEmpty( [ 1, 2, 3 ] ) ); // false
WriteOutput( IsEmpty( {} ) ); // true
WriteOutput( IsEmpty( { key="value" } ) ); // false
WriteOutput( IsEmpty( 0 ) ); // false
WriteOutput( IsEmpty( 1 ) ); // false
WriteOutput( IsEmpty( QueryNew( 'column' ) ) ); // true
WriteOutput( IsEmpty( QueryNew( 'column', 'varchar', [ [ 'value' ] ] ) ) ); // false
```