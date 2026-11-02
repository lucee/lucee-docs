
## Cancelling an inquiry

Return `false` from the listener to stop an inquiry that is still streaming, for example when the user closed the dialog or pressed a "stop" button. This works for all the built-in AI engines (OpenAI and compatible endpoints like Ollama, Claude and Gemini).

- the connection to the AI is closed, no more of the response is read
- the function returns the response received so far (the text of all chunks up to and including the one that returned `false`), it does not throw
- the partial answer is kept in the history of the session, so the session can be used for follow-up questions
- returning nothing, `true` or any value other than the boolean `false` continues the inquiry as before
