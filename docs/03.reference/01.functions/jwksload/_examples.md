```luceescript
// Parse a JSON Web Key Set (JWKS) - a JSON document containing multiple public keys
// Commonly used to verify JWTs from OAuth/OIDC providers like Auth0, Okta, Google, etc.

// Simulate a JWKS (in production, you'd fetch this from the provider's JWKS endpoint)
rsaKp = GenerateKeyPair( "RSA" );
ecKp = GenerateKeyPair( "EC" );

rsaJwk = serializeJSON( KeyToJwk( rsaKp.public ) );
ecJwk = serializeJSON( KeyToJwk( ecKp.public ) );
jwksJson = '{"keys":[' & rsaJwk & ',' & ecJwk & ']}';

// Parse the JWKS into an array of JWK structs
keys = JwksLoad( jwksJson );
// keys is an array of structs, one per key

// Full JWT verification workflow with JWKS:
// 1. Provider signs a JWT with their private key
token = JwtSign( { sub: "user123", iss: "provider" }, rsaKp.private );

// 2. Consumer fetches the provider's JWKS and finds the right key
// (in production, match by "kid" header)
keys = JwksLoad( jwksJson );
publicKey = JwkToKey( keys[ 1 ] );

// 3. Verify the token
claims = JwtVerify( token, publicKey );
// claims.sub == "user123"
```
