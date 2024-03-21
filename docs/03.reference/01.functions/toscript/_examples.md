```luceescript+trycf
  // Struct
  Struct = {};
  Struct[1] = "lucee";
  jsVar = serializeJson(Struct);
  resStruct = ToScript(struct, "jsVar");
  writeDump(resStruct);
   
  // Array
  Array = [];
  Array[1] = "lucee";
  jsVar = serializeJson(Array);
  resArr = ToScript(Array, "jsVar");
  writeDump(resArr);

  // Query
  Query = queryNew( "name,age", "varchar,numeric", {name = "Susi", age = 20 } );
  resQry = ToScript(Query, "Query");
  writeDump(resQry);

  // String
  Str = "test";
  resStr = ToScript(Str, "Str");
  writeDump(resStr);

  // Number
  number = 10;
  resNum = ToScript(number, "number");
  writeDump(resNum);
```