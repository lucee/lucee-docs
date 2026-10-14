```luceescript
// Verify an HOTP code against a secret and expected counter value
secret = TOTPSecret();
code = HOTPGenerate( secret, 5 );

// Verify at the exact counter
isValid = HOTPVerify( secret, code, 5 ); // true
isWrong = HOTPVerify( secret, code, 6 ); // false - wrong counter

// Use a window to handle counter desync (e.g. user requested a code but didn't submit it)
// window=5 checks counter values 3 through 8
isValid = HOTPVerify( secret, code, 3, { window: 5 } ); // true - counter 5 is within window

// In a real app, increment the server counter after each successful verification
// to prevent code reuse
```
