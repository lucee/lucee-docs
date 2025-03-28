---
title: ApplicationPathCacheClear
id: function-applicationpathcacheclear
related:
- tag-application
categories:
- application
- server
---

Flushes the `Application.[cfc|cfm]` path cache, default cache is 20s

Lucee has to search the filesystem per request for the appropriate `Application.cfc` or `Application.cfm`, caching this lookup improves performance.

This can be configured using a sys property/ env var

`lucee.application.path.cache.timeout` / `LUCEE_APPLICATION_PATH_CACHE_TIMEOUT` in ms

or via `.CFConfig.json`

```
{
	"applicationPathTimeout": 20000
}
```
