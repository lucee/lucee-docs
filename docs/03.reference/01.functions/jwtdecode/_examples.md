```luceescript
// JwtDecode reads the header and payload of a JWT without verifying the signature
// Useful for inspecting tokens before verification, or for debugging
secret = "my-super-secret-key-that-is-at-least-256-bits-long";
token = JwtSign(
	claims = { sub: "user123", role: "admin" },
	key = secret,
	algorithm = "HS256",
	kid = "my-key-id"
);

parts = JwtDecode( token );
// parts.header  - struct with alg, typ, kid etc.
// parts.payload - struct with all claims (sub, iat, exp, custom claims etc.)
// parts.signature - the raw signature string

// Check which algorithm was used
parts.header.alg; // "HS256"

// Read claims without needing the key
parts.payload.sub; // "user123"
parts.payload.role; // "admin"

// Inspect key ID to look up the right verification key
parts.header.kid; // "my-key-id"

// Works with any algorithm - RSA, EC, EdDSA
keyPair = GenerateKeyPair( "RSA-2048" );
token = JwtSign( claims = { sub: "rsauser" }, key = keyPair.private, algorithm = "RS256" );
parts = JwtDecode( token );
parts.header.alg; // "RS256"
```
