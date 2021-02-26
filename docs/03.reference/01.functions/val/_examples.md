```luceescript+trycf
string_number_1 = "1234 Main St.";
string_number_2 = "Main St., 1234";
string_number_3 = "123.456";

dump(Val(string_number_1)); // 1234
dump(Val(string_number_2)); // 0
dump(Val(string_number_3)); // 123
```
