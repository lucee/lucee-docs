```luceescript+trycf
key = "T5JalcfiANtOA+3V+02Ccw==";
string = "Lucee Association Switzerland (LAS)";
encrypted_string = Cfusion_encrypt(string, key);

dump(Cfusion_decrypt(encrypted_string, key)); // Lucee Association Switzerland (LAS)
```
