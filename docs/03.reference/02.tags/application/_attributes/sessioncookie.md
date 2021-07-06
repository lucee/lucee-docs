A struct which defines session cookie behaviour; the following keys are supported:

- **httpOnly (boolean):**  Specifies if the session cookies (CFID/CFTOKEN) should have the HTTPOnly cookie flag set. This prevents the cookie value from being read from JavaScript.
- **secure (boolean):**  Specifies if the session cookies (CFID/CFTOKEN) should have the secure cookie flag set. When true the cookies are only sent over a secure transport (eg HTTPS).
- **domain (string):** Specifies the cookie domain used in the session cookies (CFID/CFTOKEN).
- **timeout (string):**  Specifies the expires value of the session cookies (CFID/CFTOKEN), in days. Set to -1 for browser session cookies.
- **sameSite (string):**  Specifies if the cookies should be restricted to a first-party or same-site context. Possible values for sameSite are `lax | strict | none`
