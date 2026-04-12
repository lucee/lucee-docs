```luceescript
// Convert a JWK (JSON Web Key) back into a Java key object for signing/verification
// Accepts a struct or a JSON string

// Roundtrip: generate key pair -> export to JWK -> import back
kp = GenerateKeyPair( "RSA" );
jwk = KeyToJwk( kp.public );
publicKey = JwkToKey( jwk );

// Use the imported key to verify a JWT
token = JwtSign( { sub: "user123" }, kp.private );
claims = JwtVerify( token, publicKey );
// claims.sub == "user123"

// Also accepts a JSON string directly
json = serializeJSON( jwk );
publicKey = JwkToKey( json );

// Works with EC and Ed25519 keys too
ecKp = GenerateKeyPair( "P-256" );
ecJwk = KeyToJwk( ecKp.public );
ecPublicKey = JwkToKey( ecJwk );
```
