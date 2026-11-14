```luceescript
// SCryptHash generates a memory-hard password hash
// Defaults: N=16384 (CPU/memory cost), r=8 (block size), p=1 (parallelism)
hash = SCryptHash( "my-secret-password" );
// Output format: $scrypt$ln=14,r=8,p=1$salt$hash

// Each call produces a different hash due to random salting
hash1 = SCryptHash( "password" );
hash2 = SCryptHash( "password" );
// hash1 != hash2

// Verify with SCryptVerify()
isValid = SCryptVerify( "my-secret-password", hash ); // true

// Custom cost parameters: N (must be a power of 2), r, p
// Higher N = more memory and CPU required
hash = SCryptHash( "password", 32768, 8, 1 );
```
