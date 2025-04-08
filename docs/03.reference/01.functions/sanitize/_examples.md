```luceescript+trycf
    input = "User login with password:secretPass123";
    //Default replacement
    writeDump(sanitize(input));
    //With the replacement mask
    writeDump(sanitize(input,"-----"));
```