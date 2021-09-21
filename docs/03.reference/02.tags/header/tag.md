---
title: <cfheader>
id: tag-header
related:
- function-gethttptimestring
- function-gethttprequestdata
categories:
- core
description: Generates custom HTTP response headers to return to the client.
---

Generates custom HTTP response headers to return to the client.

If [[tag-flush]] has been used, this will throw an error.

You can detect if a page has already been flushed using

```
getPageContext().getHttpServletResponse().isCommitted();
```
