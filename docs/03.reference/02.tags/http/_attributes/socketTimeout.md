**Socket read timeout** in seconds or as a TimeSpan object. Controls how long to wait for data between consecutive data packets after the connection is established.

This timeout triggers while waiting for the server's response or if the server stops sending data mid-response. Different from connection timeout as it applies to data transfer, not connection establishment.

If not specified, falls back to the `timeout` attribute value.