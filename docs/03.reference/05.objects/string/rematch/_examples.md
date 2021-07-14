
```luceescript+trycf
str = "count 1234 or one,two,three,four.."
res = str.rematch("[a-z]+");
writeDump(res);
res = str.rematch("[a-z]");
writeDump(res);
res = str.rematch("[0-9]");
writeDump(res);
res = str.rematch("[0-9]+");
writeDump(res);
```