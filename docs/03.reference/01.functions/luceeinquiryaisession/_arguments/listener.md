A user-defined function that receives the response in chunks as they arrive from the AI. This enables real-time processing or display of the response.
The listener function should accept a single argument which will contain the response chunk.
When a listener is provided, the function still returns the complete response as a string, but also streams each chunk to the listener as it arrives.