**Always restrict algorithms in production.** Without the `algorithms` parameter, any algorithm is accepted. This can enable algorithm confusion attacks where an attacker switches from RS256 to HS256 and signs with the public key. Always specify which algorithms you expect:

```luceescript
claims = JwtVerify( token = token, key = secret, algorithms = "HS256" );
```

**throwOnError behaviour:** By default, invalid tokens throw an exception. Pass `throwOnError=false` to get a result struct instead — useful for login flows where you want to handle errors gracefully without try/catch:

- Valid: `{ valid: true, claims: { sub: "user123", ... } }`
- Invalid: `{ valid: false, error: "Token has expired" }`

**Clock skew:** Distributed systems often have small clock differences. Use `clockSkew` (in seconds) to add tolerance when checking `exp` and `nbf` claims. A value of 30–60 seconds is typical.

**Issuer and audience validation:** Always validate these in production to ensure the token was issued by the expected provider and intended for your application.
