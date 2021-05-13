```luceescript+trycf
myQuery = queryNew("custID,custName");
writeDump(queryColumnExists(myQuery,"age"));
writeDump(queryColumnExists(myQuery,"custName"));
```
