**Always implement rate limiting** on your TOTP verification endpoint. A 6-digit code only has 1 million possible values, so without rate limiting an attacker could brute-force it quickly.

The `window` parameter controls how many time steps either side of the current time are accepted. The default (1) allows one step of clock skew — about 30 seconds in each direction. Setting it to 0 requires exact time synchronisation, while higher values are more forgiving but less secure.
