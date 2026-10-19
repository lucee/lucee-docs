---
title: AIGetConnections
id: function-aigetconnections
related:
- function-aigetmetadata
- function-aihas
- function-createaisession
categories:
- ai
---

Returns all AI connections available in the current context: the connections defined in the application (for example `this.ai` in the Application.cfc) and the connections configured in the Lucee Administrator. A connection defined in the application with the same name as one in the Administrator replaces it, so it is only listed once.

Secrets like the `secretKey` and the custom settings of a connection are never returned. Use `AIGetMetaData(name)` for the details of a single connection.
