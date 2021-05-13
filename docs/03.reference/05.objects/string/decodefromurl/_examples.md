
```luceescript+trycf
enc=encodeForURL('https://download.lucee.org/?type=releases');
dump(enc);
dec=enc.decodeFromURL();
dump(dec);
```
