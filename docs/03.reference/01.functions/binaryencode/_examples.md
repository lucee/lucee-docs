```luceescript+trycf
base_64 = ToBase64("I am a string.");
binary_data = ToBinary(base_64);
dump(BinaryEncode(binary_data, "hex")); // 4920616D206120737472696E672E
```
