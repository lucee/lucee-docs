```luceescript+trycf
key=generateRSAKeys();
dump(key);

raw="Susi Sorglos föhnte Ihr Haar";
enc=encrypt(raw,key.private,"rsa");
dec=decrypt(enc,key.public,"rsa");
dump(enc);
dump(dec);

enc=encrypt(raw,key.public,"rsa");
dec=decrypt(enc,key.private,"rsa");
dump(enc);
dump(dec);
```
