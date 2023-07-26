```luceescript+trycf
letters="abcdef";
closure=function(value1,value2){return value1 & value2;}
writeOutput( stringReduce(letters,closure,"z") );
```
