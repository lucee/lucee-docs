---
title: <cfabort>
id: tag-abort
related:
categories:
- core
---

Stops processing of a page at the tag location.

CFML returns everything that was processed before the cfabort tag.

The cfabort tag is often used with conditional logic to stop processing a page when a condition occurs.

Requests that are terminated with cfabort call the Application.cfc onAbort() method instead of the onRequestEnd().
