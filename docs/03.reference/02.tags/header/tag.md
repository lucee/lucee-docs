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

If [[tag-flush]] has been used, the response is already committed and this will throw an error, unless you set `throwOnError` to `false`. In that case the header is skipped, no exception is thrown and a warning is written to the application log.

You can detect if a page has already been flushed using

```
getPageContext().getHttpServletResponse().isCommitted();
```
