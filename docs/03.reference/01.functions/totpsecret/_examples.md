```luceescript
// Generate a random TOTP secret for two-factor authentication (2FA)
// Returns a Base32-encoded string suitable for use with authenticator apps
secret = TOTPSecret();
// e.g. "JBSWY3DPEHPK3PXP4GWRGZLQ..."  (32 characters = 20 bytes)

// Each call generates a unique secret - store this securely per user
secret1 = TOTPSecret();
secret2 = TOTPSecret();
// secret1 != secret2

// Custom length (in bytes, range 16-128). Default is 20 bytes.
// Longer secrets provide more security but most authenticator apps work fine with 20
secret = TOTPSecret( 32 ); // 32 bytes = 256 bits
```
