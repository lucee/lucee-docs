BCrypt is a well-established password hashing algorithm with wide ecosystem support. It's the best choice when you need compatibility with Adobe ColdFusion or other platforms.

**Cost factor:** The default is 10. Each increment doubles the computation time. Cost 12 is a good starting point for production — aim for 0.5–1 second on your hardware. The maximum is 31 but anything above 15 will be very slow.

**Password length limit:** BCrypt silently truncates passwords at 72 bytes. If your application allows very long passwords, consider [[function-argon2hash]] instead.

For new applications where ACF compatibility isn't needed, prefer [[function-argon2hash]] which offers tuneable memory-hardness and no password length limit.

Replaces the deprecated [[function-generatebcrypthash]].
