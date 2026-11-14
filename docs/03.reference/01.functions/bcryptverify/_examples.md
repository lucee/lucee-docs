```luceescript
// Hash a password at registration time
hash = BCryptHash( "user-password" );
// Store 'hash' in your database

// At login, verify the password against the stored hash
isValid = BCryptVerify( "user-password", hash ); // true
isWrong = BCryptVerify( "wrong-password", hash ); // false

// Invalid hashes return false by default (no exception thrown)
result = BCryptVerify( "password", "not-a-valid-hash" ); // false

// Pass throwOnError=true to get an exception on invalid hashes instead
try {
	BCryptVerify( "password", "not-a-valid-hash", true );
} catch ( e ) {
	// handle the error
}
```
