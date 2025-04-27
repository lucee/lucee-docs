---
title: SerializeAISession
id: function-serializeaisession
related:
- function-loadaisession
categories:
- AI
---

Serializes an AI session to a JSON string that includes its configuration and conversation history. The serialized content includes:

- Configuration settings (temperature, limits, timeouts, system message)
- Complete conversation history with questions and answers

This function is useful for:

- Persisting AI sessions
- Debugging AI conversations
- Sharing or transferring AI session data
- Storing AI conversation history

Use `LoadAISession()` to restore a serialized session.