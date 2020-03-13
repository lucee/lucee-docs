
```luceescript+trycf
str = "count the NUMBERS 123... or ONE,TWO,THREE";
res = str.rereplacenocase("[0-9]+","[one,two,three]","all");
writeDump(res);
res = str.rereplacenocase("[a-z]+","1","all");
writeDump(res);
res = str.rereplacenocase("[a-z]","1","all");
writeDump(res);
res = str.rereplacenocase("[a-z]+","I Love Lucee","all");
writeDump(res);
```