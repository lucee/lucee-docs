```luceescript+trycf
// closure
c = function(){
  return true;
};

// user defined function (UDF)
function u() {
    return true;
}

dump(var=isClosure(c), label="closure");
dump(var=isClosure(u), label="user defined function");
```