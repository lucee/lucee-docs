```luceescript+trycf
	enc=encodeForURL('http://download.lucee.org/?type=releases');
	dump(enc);
	dec=decodeFromURL(enc);
	dump(dec);
```