```luceescript+trycf
someJson = '{"stringValue":"a string", "arrayValue": ["a","b","c"], "booleanValue":true, "numericValue": 42}';
myStruct = deserializeJson(someJson);

writeDump(myStruct);
```

*Credit to Adam Cameron for [suggesting the example](http://blog.adamcameron.me/2016/01/coldfusion-how-not-to-document-function.html)*
