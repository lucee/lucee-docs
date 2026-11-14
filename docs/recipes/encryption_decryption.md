<!--
{
  "title": "Encryption/Decryption with RSA public and private keys",
  "id": "encryption_decryption",
  "related": [
    "function-decrypt",
    "function-encrypt",
    "function-generatersakeys"
  ],
  "since": "5.3",
  "categories": [
    "crypto"
  ],
  "description": "This document explains about Encryption/Decryption with public and private keys with simple examples.",
  "menuTitle": "Public and Private keys",
  "keywords": [
    "Encryption",
    "Decryption",
    "RSA",
    "Public key",
    "Private key",
    "Lucee"
  ]
}
-->

# Encryption/Decryption

RSA is an asymmetric encryption algorithm that uses a pair of keys:

- **Private key** - used to encrypt data (keep this secret)
- **Public key** - used to decrypt data (can be shared)

This lets you encrypt something that only holders of the public key can read, or prove that data came from the private key holder.

## Generate Keys

```luceescript
// Generate a new RSA key pair
key = generateRSAKeys();
dump( key ); // struct with 'private' and 'public' keys
```

Store these keys securely - you'll need them for encrypt/decrypt operations.

## Encrypt

```luceescript
key = generateRSAKeys();
raw = "Hi, Hello !!!";

// Encrypt with the private key using RSA algorithm
enc = encrypt( raw, key.private, "rsa" );
dump( enc ); // encrypted string (Base64 encoded)
```

## Decrypt

```luceescript
key = generateRSAKeys();
raw = "Hi, Hello !!!";

// Encrypt with private key
enc = encrypt( raw, key.private, "rsa" );

// Decrypt with public key - returns original string
dec = decrypt( enc, key.public, "rsa" );
dump( dec ); // "Hi, Hello !!!"
```

Video: [Encryption/Decryption with RSA](https://www.youtube.com/watch?v=2fgfq-3nWfk)
