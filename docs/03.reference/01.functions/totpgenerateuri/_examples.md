```luceescript
// Generate an otpauth:// URI for use with authenticator apps (Google Authenticator, Authy, etc.)
// Users can scan this as a QR code to add the account to their app
secret = TOTPSecret();
uri = TOTPGenerateUri( secret, "user@example.com", "MyApp" );
// otpauth://totp/MyApp:user@example.com?secret=...&issuer=MyApp&algorithm=SHA1&digits=6&period=30

// You can generate a QR code from this URI using any QR library
// The user scans it with their authenticator app and it's configured automatically

// Custom options: change the number of digits, time period, or hash algorithm
uri = TOTPGenerateUri( secret, "user@example.com", "MyApp", {
	digits: 8,        // 8-digit codes instead of the default 6
	period: 60,       // new code every 60 seconds instead of 30
	algorithm: "SHA256" // SHA256 instead of SHA1
});

// Special characters in the issuer name are URL-encoded automatically
uri = TOTPGenerateUri( secret, "user@example.com", "My App & Co" );
```
