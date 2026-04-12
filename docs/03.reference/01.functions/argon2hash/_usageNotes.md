Argon2 is the recommended password hashing algorithm for new applications. It won the Password Hashing Competition in 2015 and is recommended by OWASP.

**Which variant?** Use the default `argon2id` — it combines side-channel resistance (from argon2i) with GPU/ASIC resistance (from argon2d). Only use `argon2i` or `argon2d` if you have specific requirements.

**Choosing parameters:** The defaults (19 MB memory, 2 iterations, parallelism 1) follow OWASP recommendations. Increase memory cost first, then iterations. The goal is to make hashing take around 0.5–1 second on your hardware.

**Why not BCrypt or SCrypt?** Argon2 is newer and has tuneable memory-hardness. BCrypt has a 72-byte password limit and no memory-hardness. SCrypt is memory-hard but harder to tune correctly. If you need compatibility with Adobe ColdFusion, use [[function-bcrypthash]] instead.

Replaces the deprecated [[function-generateargon2hash]], which uses weaker defaults for backwards compatibility.
