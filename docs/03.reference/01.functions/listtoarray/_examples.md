Simple example for listToArray function:
Uses the listToArray() function to retrieve a list as an array

```luceescript+trycf
list = "red,green,orange";
getArray = listToArray(list);
someJSON = serializeJSON(getArray);
writeOutput(someJSON);
```

Expected Result: `["red", "green", "orange"]`

Example for listToArray function with delimiter:
Uses the listToArray() function with a semicolon delimiter to retrieve a list as an array

```luceescript+trycf
list = "coldfusion;php;java;sql";
getArray = listToArray(list,";");
someJSON = serializeJSON(getArray);
writeOutput(someJSON);
```

Expected Result: `["coldfusion", "php", "java", "sql"]`

Example for listToArray function with includeEmptyFields:
If includeEmptyFields is true, empty value add in array elements

```luceescript+trycf
list = "coldfusion;php;;java;sql";
getArray = listToArray(list,";",true);
someJSON = serializeJSON(getArray);
writeOutput(someJSON);
```

Expected Result: `["coldfusion", "php", " " , "java", "sql"]`

Example for listToArray function with multiCharacterDelimiter:
Uses the listToArray() function to retrieve a list as an array with multiCharacterDelimiter

```luceescript+trycf
list = "coldfusion,php,|test,java,|sql";
getArray = listToArray(list,",|",false,true);
someJSON = serializeJSON(getArray);
writeOutput(someJSON
);
```

Expected Result: `["coldfusion,php", "test,java", "sql"]`
