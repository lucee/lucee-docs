```luceescript
// Argon2Hash uses OWASP-recommended defaults: argon2id, 19 MB memory, 2 iterations
// This is the recommended password hashing function for new applications
hash = Argon2Hash( "my-secret-password" );
// Output is in PHC format: $argon2id$v=19$m=19456,t=2,p=1$salt$hash

// Like BCrypt, each call produces a different hash due to random salting
hash1 = Argon2Hash( "password" );
hash2 = Argon2Hash( "password" );
// hash1 != hash2

// Verify with Argon2Verify()
isValid = Argon2Verify( "my-secret-password", hash ); // true

// Custom parameters: variant, parallelism, memoryCost (KB), iterations
// argon2id is recommended - it combines side-channel resistance (argon2i)
// with GPU resistance (argon2d)
hash = Argon2Hash( "password", "argon2id", 2, 19456, 2 );

// Other variants are available if you have specific requirements
hashI = Argon2Hash( "password", "argon2i", 1, 8192, 2 );
hashD = Argon2Hash( "password", "argon2d", 1, 8192, 2 );
```
