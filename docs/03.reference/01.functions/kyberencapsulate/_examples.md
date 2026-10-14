```luceescript
// Kyber is a post-quantum key encapsulation mechanism (KEM)
// It lets two parties agree on a shared secret that's resistant to quantum computers
// Typical use: establish a shared secret, then use it for symmetric encryption (AES)

// Step 1: Recipient generates a Kyber key pair and shares the public key
keys = GenerateKeyPair( "Kyber768" );

// Step 2: Sender encapsulates - produces a shared secret and a ciphertext
encapResult = KyberEncapsulate( keys.public );
// encapResult.sharedSecret - binary, use this for encryption
// encapResult.ciphertext   - send this to the recipient

// Step 3: Recipient decapsulates with their private key to get the same shared secret
sharedSecret = KyberDecapsulate( keys.private, encapResult.ciphertext );
// sharedSecret == encapResult.sharedSecret

// Each encapsulation produces different ciphertext (randomised)
// but decapsulation always recovers the matching shared secret

// Use the shared secret for AES encryption
senderKey = binaryEncode( encapResult.sharedSecret, "base64" );
encrypted = Encrypt( "Hello, quantum-safe world!", senderKey, "AES/CBC/PKCS5Padding", "Base64" );

// Available Kyber variants (higher = more security, larger keys):
// Kyber512, Kyber768 (recommended), Kyber1024, ML-KEM-768 (alias)
```
