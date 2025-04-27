A UDF Listener which receives a single argument, output. 
Optional, If a OnProgress Listener is defined, but no onError listener, the error stream is redirected to the onProgress Listener.
Returning false from the Listener will cancel the process execution