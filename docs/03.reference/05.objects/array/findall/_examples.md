```luceescript+trycf
	numbers = [ "one", "two", "three", "four", "one", "one", "two", "one" ];
	dump( numbers.findall( "one" ) ) ; // [ 1,5, 6, 8 ]

	fruits = [ "apple", "orange", "banana", "orange", "orange" ];
	dump( fruits.findall( "orange" ) ); // [ 2, 4, 5 ]

	notOranges = arrayFindAll( fruits,
		function( el ){ 
			return arguments.el neq 'oranges';
	});
	dump( notOranges ); // [ 1, 3 ]
```