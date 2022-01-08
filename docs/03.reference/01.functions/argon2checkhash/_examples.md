```luceescript+trycf
    secret = createUUID();
    dump(var=secret, label="input string");
    
    hashed = generateArgon2Hash(secret);
    dump(var=hashed, label="generateArgon2Hash");
    
    decoded= argon2checkhash(secret, hashed);
    dump(var=decoded, label="argon2checkhash matches");
```
