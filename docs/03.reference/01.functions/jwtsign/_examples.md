```luceescript
// Sign a JWT with a shared HMAC secret (simplest approach)
secret = "my-super-secret-key-that-is-at-least-256-bits-long";
token = JwtSign(
	claims = { sub: "user123", role: "admin" },
	key = secret,
	algorithm = "HS256"
);
// token is a string like: eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOi...

// Set expiration and issuer
token = JwtSign(
	claims = { sub: "user123", role: "admin" },
	key = secret,
	algorithm = "HS256",
	expiresIn = 3600, // expires in 1 hour (seconds)
	issuer = "https://myapp.com",
	audience = "api"
);

// The iat (issued-at) claim is set automatically
// If you set exp explicitly in claims, it takes precedence over expiresIn

// Sign with RSA keys (asymmetric - sign with private, verify with public)
keyPair = GenerateKeyPair( "RSA-2048" );
token = JwtSign(
	claims = { sub: "user123", admin: true },
	key = keyPair.private,
	algorithm = "RS256"
);

// Sign with EC keys
keyPair = GenerateKeyPair( "P-256" );
token = JwtSign(
	claims = { sub: "user123" },
	key = keyPair.private,
	algorithm = "ES256"
);

// Algorithm auto-detection: if you omit algorithm, it's inferred from the key type
// RSA key -> RS256, P-256 -> ES256, P-384 -> ES384, P-521 -> ES512, Ed25519 -> EdDSA
keyPair = GenerateKeyPair( "Ed25519" );
token = JwtSign( claims = { sub: "user123" }, key = keyPair.private );
// Algorithm is automatically set to EdDSA

// Positional arguments are also supported: claims, key, algorithm
token = JwtSign( { sub: "user123" }, secret, "HS256" );
```
