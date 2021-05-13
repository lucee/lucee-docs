Applies if action = "wddx2cfml" or "wddx2js".

- Yes: validates WDDX input with an XML parser using
WDDX DTD. If parser processes input without error,
packet is deserialized. Otherwise, an error is
thrown.
- No: no input validation
