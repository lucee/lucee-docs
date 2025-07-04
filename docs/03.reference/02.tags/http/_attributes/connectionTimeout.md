**Connection establishment timeout** in seconds or as a TimeSpan object. Controls how long to wait while establishing the initial TCP connection to the server.

This timeout triggers during the TCP handshake phase, before any HTTP data is sent. Useful when the target server is unreachable, experiencing network issues, or is overwhelmed and not accepting new connections.

If not specified, falls back to the `timeout` attribute value.