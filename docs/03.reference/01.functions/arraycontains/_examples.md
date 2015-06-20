```luceescript
numbers = [ 1, 2, 3, 4 ];
// Returns the array position of the number 3 in the 'numbers' array.
positionOfThree = ArrayContains( numbers, 3 );

echo( positionOfThree ); // outputs 3

words = [ 'hello' , 'world' ];
// Returns the array position of the string 'world' in the 'words' array.
positionOfWorld = ArrayContains( words, 'world' );

echo( positionOfWorld ); // outputs 2

// Returns the array position of the substring 'el' in the 'words' array.
positionOfEl = ArrayContains( words, 'el', true );

echo( positionOfEl ); // outputs 1
```
