HOTP uses a counter rather than time. Your application is responsible for storing and incrementing the counter after each successful verification. If you don't need counter-based OTP specifically, prefer TOTP ([[function-totpverify]]) which handles the counter automatically using the current time.

The secret must be a Base32-encoded string. Use [[function-totpsecret]] to generate one.
