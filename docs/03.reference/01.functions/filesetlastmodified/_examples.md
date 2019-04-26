```luceescript
filesetlastmodified(expandPath("./testcase.txt"),#dateAdd("d", 2, now())#);
writeDump(getfileinfo(expandPath("./testcase.txt")).lastmodified);
```