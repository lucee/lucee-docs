### Simple example for Len

```luceescript+trycf
str="I love lucee";
dump(var=len(str), label="String");
dump(str);

arr =[1,2,3];
dump(var=len(arr), label="Array");
dump(arr);

st ={ a: 1};
dump(var=len(st), label="Struct");
dump(st);

q =query(a:["1,2,3"]);
dump(var=len(st), label="Query");
dump(q);
```

### Member Function

```luceescript+trycf
str=['I','love','lucee'];
writeOutput(str.len());//3
```
