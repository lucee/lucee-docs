```luceescript+trycf
base_64 = ToBase64("I am a string.");
binary_data = ToBinary(base_64);
dump(BinaryEncode(binary_data, "hex")); // 4920616D206120737472696E672E
```

```luceescript+trycf
// Base64URL as used by JWT: URL safe alphabet (- and _) and no padding
binary_data = BinaryDecode("FBFFFE", "hex");
dump(BinaryEncode(binary_data, "base64"));    // +//+
dump(BinaryEncode(binary_data, "base64url")); // -__-
dump(BinaryEncode(BinaryDecode("66", "hex"), "base64url")); // Zg
```
