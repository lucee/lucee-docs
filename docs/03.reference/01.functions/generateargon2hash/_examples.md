```luceescript
// GenerateArgon2Hash is deprecated - use Argon2Hash() instead for OWASP-recommended defaults
// GenerateArgon2Hash uses weaker defaults (argon2i, 8 KB memory, 1 iteration) for backwards compatibility
password = "my-secret-password";
hash = GenerateArgon2Hash( password );

// Verify with Argon2CheckHash (also deprecated - use Argon2Verify)
isValid = Argon2CheckHash( password, hash ); // true

// Custom parameters: variant, parallelism, memoryCost (KB), iterations
hash = GenerateArgon2Hash( password, "argon2id", 1, 8192, 2 );
```
