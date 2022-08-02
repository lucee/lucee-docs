### Find all the positions of all occurrences of a string in array

```luceescript+trycf
fruitArray = [ 'apple', 'kiwi', 'banana', 'orange', 'mango', 'kiwi' ];

favoriteFruits = arrayFindAll( fruitArray, 'kiwi' );
dump( favoriteFruits ); // [ 2, 6 ]

notKiwis = arrayFindAll( fruitArray,
    function( el ){ 
        return arguments.el neq 'kiwi';
});
dump( notKiwis ); // [1,3,4,5]

```