```luceescript
// Verify an HMAC-signed token - returns the claims struct on success
secret = "my-super-secret-key-that-is-at-least-256-bits-long";
token = JwtSign( { sub: "user123", role: "admin" }, secret, "HS256" );

claims = JwtVerify( token = token, key = secret );
// claims.sub == "user123", claims.role == "admin"

// Verify an RSA-signed token with the public key
keyPair = GenerateKeyPair( "RSA-2048" );
token = JwtSign( claims = { sub: "user123" }, key = keyPair.private, algorithm = "RS256" );
claims = JwtVerify( token = token, key = keyPair.public );

// By default, invalid tokens throw an exception. Use throwOnError=false to get
// a result struct instead - useful for login flows where you want to handle errors gracefully
result = JwtVerify( token = token, key = "wrong-key", throwOnError = false );
// result.valid == false, result.error contains the error message

result = JwtVerify( token = token, key = keyPair.public, throwOnError = false );
// result.valid == true, result.claims contains the decoded claims

// Validate issuer and audience - throws if they don't match
token = JwtSign(
	claims = { sub: "user123" },
	key = secret,
	algorithm = "HS256",
	issuer = "https://myapp.com",
	audience = "api"
);
claims = JwtVerify(
	token = token,
	key = secret,
	issuer = "https://myapp.com",
	audience = "api"
);

// Allow clock skew for expiration checks (useful for distributed systems)
// This allows tokens up to 60 seconds past their expiration
claims = JwtVerify( token = token, key = secret, clockSkew = 60 );

// Restrict which algorithms are accepted (security best practice)
claims = JwtVerify( token = token, key = secret, algorithms = [ "HS256", "HS384" ] );
// or as a comma-separated string
claims = JwtVerify( token = token, key = secret, algorithms = "HS256,HS384" );

// Positional arguments: token, key
claims = JwtVerify( token, secret );
```
