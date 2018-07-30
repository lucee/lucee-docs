```luceescript+trycf
writeDump(replace("xxabcxxabcxx","abc","def"));
writeDump(replace("xxabcxxabcxx","abc","def","All"));
writeDump(replace("abc","a","b","all"));
writeDump(replace("a.b.c.d",".","-","all"));
test = "camelcase CaMeLcAsE CAMELCASE";
test2 = Replace(test, "camelcase", "CamelCase", "all");
writeDump(test2);
```
