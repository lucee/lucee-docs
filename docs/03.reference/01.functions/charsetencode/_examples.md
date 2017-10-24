```luceescript+trycf
decoded = CharsetDecode("I am a string.", "utf-8"); 
dump(CharsetEncode(decoded, "utf-8")); // "I am a string"
```
