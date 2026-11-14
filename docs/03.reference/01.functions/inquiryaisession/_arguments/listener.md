A user-defined function that receives the response in chunks as they arrive from the AI. This enables real-time processing or display of the response.

The listener function receives the response chunk as its first argument, followed by the chunk number, whether this is the last chunk, the type of the chunk (`text` or `binary`), its content type and the part number.

When a listener is provided, the function still returns the complete response, but also streams each chunk to the listener as it arrives.

The listener can cancel the inquiry by returning boolean `false` *(since 9.0)*. Lucee then stops reading the response, closes the connection to the AI and returns what has been received so far, including the chunk the listener was called with when it returned `false`. The listener is not called again. A listener that returns nothing, `true` or any other value does not cancel, the response is streamed to the end.
