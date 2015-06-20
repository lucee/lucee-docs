```luceescript
// An array with 4 elements with the numbers 1 - 4 in it.
numbers = [ 1, 2, 3, 4 ];
// Add a fifth element to the array so the array now has 5 elements with the numbers 1 - 5 in it.
ArrayAppend( numbers, 5 );

// An array with 4 elements with the numbers 1 - 4 in it.
numbers = [ 1, 2, 3, 4 ];
// Another array with 4 elements with the numbers 5 - 8 in it.
moreNumbers = [ 5, 6, 7, 8 ];
// Combines the two arrays so the 'numbers' array now has 8 elements with the numbers 1 - 8 in it.
ArrayAppend( numbers, moreNumbers, true );

// An array with 4 elements with the numbers 1 - 4 in it.
numbers = [ 1, 2, 3, 4 ];
// Another array with 4 elements with the numbers 5 - 8 in it.
moreNumbers = [ 5, 6, 7, 8 ];
// Appends the 'moreNumber' array to the 'numbers' array to create an array with 5 elements with the numbers 1 - 4 in it and the fifth element containing an array with the numbers 5 - 8 in it.
ArrayAppend( numbers, moreNumbers, false );
```
