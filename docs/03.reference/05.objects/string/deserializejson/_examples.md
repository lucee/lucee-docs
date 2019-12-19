```luceescript+trycf
world = '{"save":"water","clean":"wastes"}';
res1 = deserializeJson(world);
writeDump(res1);
writeDump(res1.save);
writeDump(isstruct(res1));
```