```luceescript+trycf
  myStruct = structNew();
  mystruct.id = 1;
  mystruct.Name = "Water";
  mystruct.DESIGNATION = "Important source for all";
  serialize_test = serializeJSON(myStruct);
  writeDump(serialize_test);
```