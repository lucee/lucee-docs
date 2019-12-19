
```luceescript+trycf
str = "count 1234 or one,two,three,four.."
res = str.rematchnocase("[A-Z]+");
writeDump(res);
res = str.rematchnocase("[a-z]+");
writeDump(res);
res = str.rematchnocase("(0-4)");
writeDump(res);
res = str.rematchnocase("[0-4]*");
writeDump(res);
res = str.rematchnocase("[0-9]+");
writeDump(res);
```