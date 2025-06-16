---
title: LoadAISession
id: function-loadaisession
related:
- function-serializeaisession
categories:
- AI
---

Restores an AI session from a serialized JSON string or struct. This function recreates an AI session with:

- Original configuration settings (temperature, limits, timeouts)
- Complete conversation history
- System message prompt

The function supports loading sessions by:

- AI engine name
- Engine ID (using `id:` prefix)
- Default engine (using `default:` prefix)

This function pairs with `SerializeAISession()` to provide persistence for AI conversations across requests or application restarts.