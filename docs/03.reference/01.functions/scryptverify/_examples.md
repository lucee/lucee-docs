```luceescript
// Hash a password at registration time
hash = SCryptHash( "user-password" );
// Store 'hash' in your database

// At login, verify the password against the stored hash
isValid = SCryptVerify( "user-password", hash ); // true
isWrong = SCryptVerify( "wrong-password", hash ); // false

// Invalid or non-SCrypt hashes return false by default
result = SCryptVerify( "password", "not-a-valid-hash" ); // false
result = SCryptVerify( "password", "$2a$10$somebcrypthash" ); // false

// Pass throwOnError=true to get an exception on invalid hashes
try {
	SCryptVerify( "password", "not-a-valid-hash", true );
} catch ( e ) {
	// handle the error
}
```
