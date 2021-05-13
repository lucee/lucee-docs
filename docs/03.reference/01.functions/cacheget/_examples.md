```luceescript+trycf
  cachePut(id:'abc', value:'123',timeSpan:CreateTimeSpan(0,0,0,1),cacheName:'fruits');
  getcache = cacheGet(id:'abc',cacheName:'fruits');
  writeDump(getcache);
```
