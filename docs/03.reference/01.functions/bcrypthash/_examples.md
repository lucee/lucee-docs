```luceescript
// BCryptHash generates a salted hash - each call produces a different result
hash1 = BCryptHash( "my-secret-password" );
hash2 = BCryptHash( "my-secret-password" );
// hash1 != hash2 because BCrypt uses a random salt each time

// The default cost factor is 10. Higher cost = slower but harder to brute-force.
// Cost is exponential: cost 12 is 4x slower than cost 10.
hash = BCryptHash( "my-secret-password", 12 );

// Verify a password against a stored hash using BCryptVerify()
isValid = BCryptVerify( "my-secret-password", hash ); // true
isWrong = BCryptVerify( "wrong-password", hash ); // false
```
