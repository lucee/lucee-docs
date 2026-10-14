**General timeout value** in seconds or as a TimeSpan object that serves as a fallback for connection and socket timeouts. 

When `connectionTimeout` or `socketTimeout` are not specified, this value is used for those timeouts.

If no timeout is set, Lucee uses the **remaining request timeout** from the current page context. 
The request will always timeout at or before the page timeout, using whichever is smaller: the specified timeout or remaining request time.
