
```luceescript+trycf
str = "count the NUMBERS 123... or ONE,TWO,THREE";
res = str.rereplace("[0-9]+","[one,two,three]","all");
writeDump(res);
res = str.rereplace("[a-z]+","1","all");
writeDump(res);
res = str.rereplace("[a-z]","1","all");
writeDump(res);
res = str.rereplace("[a-z]+","I Love Lucee","all");
writeDump(res);
```
