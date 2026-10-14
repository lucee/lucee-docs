The cost factor is encoded in the hash, so you don't need to specify it when verifying. This means you can increase the cost over time and existing hashes will still verify correctly.

By default, invalid or malformed hashes return `false`. Pass `throwOnError=true` if you want an exception instead.

Replaces the deprecated [[function-verifybcrypthash]].
