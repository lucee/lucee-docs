The algorithm to use to generate the random number.
			- CFMX_COMPAT (very simple and not very secure algorithm (default)).
            - SHA1PRNG (generates a number using the Sun Java SHA1PRNG algorithm. This algorithm provides greater randomness than the default algorithm)
            - IBMSecureRandom (IBM JVM does not support the SHA1PRNG algorithm)