The hash encodes which variant and parameters were used, so you don't need to specify them when verifying. This means you can upgrade your hashing parameters over time without breaking existing stored hashes.

By default, invalid or malformed hashes return `false`. Pass `throwOnError=true` if you want an exception instead — useful for catching data corruption. A wrong password always returns `false` regardless of this setting.

Replaces the deprecated [[function-argon2checkhash]] and [[function-verifyargon2hash]].
