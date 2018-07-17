```luceescript+trycf
list=",,a,,b,c,,e,f";
// base test
res=ListSome(list, function(value ){return value =='a';},',',false,true, true);
writeDump(res);
res=ListSome(list, function(value ){return value =='z';},',',false,true,false);
writeDump(res);
```