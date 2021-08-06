### Arraypop member examples

```luceescript+trycf
	numbers = [ 1, 2, 3, 4 ];
	Dump( numbers.pop( 0 ) ); // Outputs 4

	moreNumbers = [ 5, 6, 7, 8 ];
	Dump( moreNumbers.pop( 4 ) ); // Outputs 8

	moreNumbers = [  ];
	Dump( moreNumbers.pop( 4 ) ); // Outputs 4
```