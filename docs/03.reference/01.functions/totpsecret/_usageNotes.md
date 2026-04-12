Store the secret securely in your database — it's equivalent to a password. Only show it to the user once during 2FA setup (typically as a QR code via [[function-totpgenerateuri]]).

The default 20-byte secret is sufficient for most applications. Google Authenticator and most other apps work with 20-byte secrets.
