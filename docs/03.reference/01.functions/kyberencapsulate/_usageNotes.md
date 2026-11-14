Kyber is a key encapsulation mechanism (KEM), not an encryption function. It produces a shared secret that both parties can derive independently — you then use that shared secret with a symmetric cipher like AES for actual encryption.

The shared secret is different each time you call KyberEncapsulate, even with the same public key. This is by design — each encapsulation is randomised.

Only Kyber public keys are accepted. Passing an RSA or EC key will throw an exception.

**Which variant?** Kyber768 (ML-KEM-768) is the recommended default, balancing security and performance. Kyber512 is faster with smaller keys but provides lower security. Kyber1024 provides the highest security at the cost of larger keys and ciphertexts.
