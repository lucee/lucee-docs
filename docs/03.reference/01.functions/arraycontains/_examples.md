```luceescript
numbers         = [ 1, 2, 3, 4 ];
positionOfThree = ArrayContains( numbers, 3 );
Echo( positionOfThree ); // outputs 3

words               = [ 'hello' , 'world' ];
positionOfWorld     = ArrayContains( words, 'world' );
positionOfSubstring = ArrayContains( words, 'el', true );
Echo( positionOfSubstring ); // outputs 1
Echo( positionOfWorld     ); // outputs 2
```
