```luceescript+trycf
	numbers = [ 4, 3, 2, 1 ];
	dump(var=numbers, label="numbers");

	positionOfThree = ArrayContains( numbers, 3);
	echo("Position of 3: " & positionOfThree & "<br>"); // outputs 2

	words = [ 'hello' , 'world' ];
	dump(var=words, label="Words");

	positionOfWorld = ArrayContains( words, 'world' );
	positionOfSubstring = ArrayContains( words, 'el', true ); // substring matching

	echo("Position of substring 'el': " & positionOfSubstring & "<br>" ); // outputs 1
	echo("Position of 'World': " & positionOfWorld); // outputs 2
```