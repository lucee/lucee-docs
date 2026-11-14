```luceescript
// HOTP generates a one-time password based on a counter value (RFC 4226)
// Unlike TOTP which uses time, HOTP uses a counter that increments with each use
secret = TOTPSecret(); // Base32-encoded shared secret

// Generate a 6-digit code for counter value 0
code = HOTPGenerate( secret, 0 );
// e.g. "755224" - always the same for the same secret and counter

// HOTP is deterministic - same secret + counter always gives the same code
code1 = HOTPGenerate( secret, 42 );
code2 = HOTPGenerate( secret, 42 );
// code1 == code2

// Different counters produce different codes
codeA = HOTPGenerate( secret, 0 );
codeB = HOTPGenerate( secret, 1 );
// codeA != codeB

// Options: change digit count or algorithm
code = HOTPGenerate( secret, 0, { digits: 8 } ); // 8-digit code
code = HOTPGenerate( secret, 0, { algorithm: "SHA256" } );
code = HOTPGenerate( secret, 0, { algorithm: "SHA512" } );
```
