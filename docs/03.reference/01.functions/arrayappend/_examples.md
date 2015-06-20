```luceescript
numbers = [ 1, 2, 3, 4 ];
ArrayAppend( numbers, 5 );
Dump( numbers ); // Outputs [ 1, 2, 3, 4, 5 ]

numbers     = [ 1, 2, 3, 4 ];
moreNumbers = [ 5, 6, 7, 8 ];
ArrayAppend( numbers, moreNumbers );
Dump( numbers ); // Outputs [ 1, 2, 3, 4, [ 5, 6, 7, 8 ] ]

numbers     = [ 1, 2, 3, 4 ];
moreNumbers = [ 5, 6, 7, 8 ];
ArrayAppend( numbers, moreNumbers, true );
Dump( numbers ); // Outputs [ 1, 2, 3, 4, 5, 6, 7, 8 ]


```
