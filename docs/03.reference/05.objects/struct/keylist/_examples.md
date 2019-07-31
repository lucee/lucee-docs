
```luceescript+trycf
world = {"save":"water","clean":"wastes","save":"money"};
res = world.keylist();
writeDump(res);
res = world.keylist("@");
writeDump(res);
res = world.keylist("-");
writeDump(res);
res = world.keylist("A");
writeDump(res);
```