```luceescript+trycf
numbers = [ 1, 2, 3, 4 ];
numbers .Shift( );
Dump( numbers ); // Outputs 1

moreNumbers = [ 5, 6, 7, 8 ];
moreNumbers .Shift( );
Dump( numbers ); // Outputs 5

numbers     = [ "one", "two", "three", "four" ];
numbers.Shift( );
Dump( numbers ); // Outputs one

```