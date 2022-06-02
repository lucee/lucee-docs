```luceescript+trycf
writeDump(isInstanceOf({},"java.util.Map")); // true
writeDump(isInstanceOf("Lucee","java.util.Map")); // false
writeDump(isInstanceOf("Lucee","java.lang.String")); // true
```