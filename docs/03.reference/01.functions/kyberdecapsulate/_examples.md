```luceescript
// Decapsulate a Kyber ciphertext to recover the shared secret
// This is the recipient's side of the Kyber key exchange

// Recipient's key pair (private key must be kept secret)
keys = GenerateKeyPair( "Kyber768" );

// Sender encapsulates using recipient's public key
encapResult = KyberEncapsulate( keys.public );
// Sender transmits encapResult.ciphertext to the recipient

// Recipient decapsulates to recover the shared secret
sharedSecret = KyberDecapsulate( keys.private, encapResult.ciphertext );

// Use the shared secret for symmetric decryption
recipientKey = binaryEncode( sharedSecret, "base64" );
// decrypted = Decrypt( encrypted, recipientKey, "AES/CBC/PKCS5Padding", "Base64" );

// Wrong private key produces a different (incorrect) shared secret
// rather than throwing an error - this is by design (implicit rejection)
```
