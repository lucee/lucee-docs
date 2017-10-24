```luceescript+trycf
test_query = queryNew("name , age" , "varchar , numeric", { name: [ "John Doe" , "Jane Doe", "Frank Jones" ] , age: [ 20 , 24, 33 ] });
dump(ValueList(test_query.name, "; "));
```
