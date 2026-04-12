SCrypt is a memory-hard password hashing algorithm. It's harder to attack with GPUs/ASICs than BCrypt because it requires large amounts of memory.

**Parameters:** The cost parameter N must be a power of 2 (e.g. 4096, 8192, 16384). The defaults (N=16384, r=8, p=1) are reasonable for most applications. Increase N to make hashing slower and more memory-intensive.

For new applications, prefer [[function-argon2hash]] which is easier to tune and was specifically designed to improve on SCrypt's design.

Replaces the deprecated [[function-generatescrypthash]].
