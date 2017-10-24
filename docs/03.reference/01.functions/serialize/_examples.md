```luceescript+trycf
struct_object = { name = "Joe", email = "joe@example.com" };
array_object = ["John Doe", { name = "Joe", email = "joe@example.com" }, 1000];
java_object = createObject("java", "java.lang.StringBuffer").init("");

dump(Serialize(struct_object)); // {'name':'Joe','email':'joe@example.com'}
dump(Serialize(array_object)); // ['John Doe',{'name':'Joe','email':'joe@example.com'},1000]
dump(Serialize(java_object));
```
