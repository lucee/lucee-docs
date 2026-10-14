The cost parameters are encoded in the hash, so you don't need to specify them when verifying. Non-SCrypt hashes (e.g. a BCrypt hash) return `false` rather than throwing.

By default, invalid or malformed hashes return `false`. Pass `throwOnError=true` if you want an exception instead.

Replaces the deprecated [[function-verifyscrypthash]].
