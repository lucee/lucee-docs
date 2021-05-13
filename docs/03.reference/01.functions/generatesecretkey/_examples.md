```luceescript+trycf
	ex={};
	ex.algo="RC4";
	ex.value="554122";
	ex.key=GenerateSecretKey(ex.algo);
	ex.enc=Encrypt(ex.value, ex.key, ex.algo);
	ex.dec=Decrypt(ex.enc, ex.key, ex.algo);
	dump(ex);
```
