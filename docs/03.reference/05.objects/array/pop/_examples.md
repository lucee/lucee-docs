### Arraypop member examples

```luceescript+trycf
	numbers = [ 1, 2, 3, 4 ];
	dump( numbers.pop( 0 ) ); // Outputs 4
	dump( numbers ); // Outputs [ 1, 2, 3 ]

	moreNumbers = [ 5, 6, 7, 8 ];
	dump( moreNumbers.pop( 4 ) ); // Outputs 8
	dump( moreNumbers ); // outputs [ 5, 6, 7 ]

	moreNumbers = [  ];
	dump( moreNumbers.pop( 4 ) ); // Outputs 4 (default)
	dump( moreNumbers ); // Outputs [  ];
```
