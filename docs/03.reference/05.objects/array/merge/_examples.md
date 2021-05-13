
```luceescript+trycf
myarray = ["one","two","three","four","five"];
myarray1 = ["six","seven","eight"];
res = myarray.merge(myarray1);
writeDump(res);
res = myarray1.merge(myarray);
writeDump(res);
res = myarray.merge(myarray1,true);
writeDump(res);
```
