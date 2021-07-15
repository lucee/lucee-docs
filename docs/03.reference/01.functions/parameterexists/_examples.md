```luceescript+trycf
  bool = true;
	string = "I'm a string";
	numeric = 100;

	boolean_exists = ParameterExists("bool");
	string_exists = ParameterExists("string");
	number_exists = ParameterExists("number");

	dump(boolean_exists); //true
	dump(string_exists); //true
	dump(number_exists); //false
```
