```luceescript+trycf
base_64 = ToBase64("I am a string.");
binary_data = ToBinary(base_64);
encoded_binary = BinaryEncode(binary_data, "hex");
dump(BinaryDecode(encoded_binary, "hex"));
```
