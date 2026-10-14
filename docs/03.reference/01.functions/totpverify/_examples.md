```luceescript
// Verify a TOTP code entered by the user during 2FA login
secret = TOTPSecret(); // stored per user at registration time

// In a real app, the code comes from the user's authenticator app
code = "123456"; // user-entered code
isValid = TOTPVerify( secret, code );

// By default, window=1 allows one time step of clock skew (30 seconds either side)
// This handles small clock differences between server and user's device

// Strict verification with no clock skew tolerance
isValid = TOTPVerify( secret, code, { window: 0 } );

// Wider window for systems with known clock drift
isValid = TOTPVerify( secret, code, { window: 2 } );
```
