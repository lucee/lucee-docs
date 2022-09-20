```luceescript+trycf
numbers = [ 1, 2, 3, 4 ];
numbers.Shift( );
Dump( numbers ); // Outputs [ 2, 3, 4 ]

moreNumbers = [ 5, 6, 7, 8 ];
moreNumbers.Shift( );
Dump( numbers ); // Outputs [ 6, 7, 8 ]

someArray     = [ "one", "two", "three", "four" ];
someArray.Shift( );
Dump( someArray ); // Outputs [ "two", "three", "four" ]

```
