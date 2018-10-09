```luceescript+trycf
writeDump(replaceNoCase("xxabcxxabcxx","ABC","def"));
writeDump(replaceNoCase("xxabcxxabcxx","abc","def","All"));
writeDump(replaceNoCase("xxabcxxabcxx","AbC","def","hans"));
writeDump(replaceNoCase("a.b.c.d",".","-","all"));
test = "camelcase CaMeLcAsE CAMELCASE";
test2 = replaceNoCase(test, "camelcase", "CamelCase", "all");
writeDump(test2);
```

