```luceescript+trycf
key = "+nn7jqV+3hYHM++RuvE47g==";
new_token = CSRFGenerateToken(key, true);
dump(CSRFVerifyToken(new_token,key)); //true
```
