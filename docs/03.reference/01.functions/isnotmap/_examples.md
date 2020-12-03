```luceescript+trycf
a = structNew();
dump(a);
dump(isNotMap(a));

b = CreateObject("java", "java.util.Map");
dump(var=b, expand=false);
dump(isNotMap(b));
```