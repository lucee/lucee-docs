```luceescript
// Hash a password at registration time
hash = Argon2Hash( "user-password" );
// Store 'hash' in your database

// At login, verify the password against the stored hash
isValid = Argon2Verify( "user-password", hash ); // true
isWrong = Argon2Verify( "wrong-password", hash ); // false

// Argon2Verify works with all three variants (argon2i, argon2d, argon2id)
// The variant is encoded in the hash, so you don't need to specify it
hashI = Argon2Hash( "password", "argon2i", 1, 8192, 1 );
hashD = Argon2Hash( "password", "argon2d", 1, 8192, 1 );
Argon2Verify( "password", hashI ); // true
Argon2Verify( "password", hashD ); // true

// Invalid hashes return false by default
result = Argon2Verify( "password", "not-a-valid-hash" ); // false

// Pass throwOnError=true to get an exception on invalid hashes
// Note: a wrong password still returns false, only malformed hashes throw
try {
	Argon2Verify( "password", "not-a-valid-hash", true );
} catch ( e ) {
	// handle the error
}
```
