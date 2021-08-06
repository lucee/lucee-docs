The following statements all evaluate to true:

```luceescript+trycf
writeOutput('Strings');
writeDump(IsEmpty( '' )); // true;
writeDump(IsEmpty( ' ' )); // false;
writeDump(IsEmpty( '0' )); // false;

writeOutput('arrays');
writeDump(IsEmpty( [] )); // true;
writeDump(IsEmpty( [ 1, 2, 3 ] )); // false;

writeOutput('structs');
writeDump(IsEmpty( {} )); // true;
writeDump(IsEmpty( { key="value" } )); // false;

writeOutput('queries');
writeDump(IsEmpty( QueryNew( 'column' ) )); // true;
writeDump(IsEmpty( QueryNew( 'column', 'varchar', [ [ 'value' ] ] ) )); // false;

writeOutput('numerics always non-empty');
writeDump(IsEmpty( 0 )); // false;
writeDump(IsEmpty( 1 )); // false;

writeOutput('booleans always non-empty');
writeDump(IsEmpty( false )); // false;
writeDump(IsEmpty( true )); // false;
```

>>>> Prior to Lucee 4.5.1.016, `IsEmpty( 0 )` and `IsEmpty( false )` both returned true.