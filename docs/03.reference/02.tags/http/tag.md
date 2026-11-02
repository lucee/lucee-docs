---
title: <cfhttp>
id: tag-http
related:
- tag-ftp
- tag-httpparam
categories:
- cache
- core
- protocols
description: Lets you execute HTTP POST and GET operations on files.
---

Lets you execute HTTP POST and GET operations on files.

Using cfhttp, you can execute standard GET operations and create a query object from a text file.

POST operations lets you upload MIME file types to a server, or post cookie, formfield, URL, file, or CGI variables directly to a specified server.


## Request details in the result

The result struct contains a `request` key (Lucee 9.0 and later) that describes the request that was sent, useful for debugging dynamically built requests.

| Key | Description |
|-----|-------------|
| `method` | The HTTP method. |
| `url` | The requested URL. |
| `finalUrl` | The URL of the final response after redirects. Equals `url` if no redirect was followed or the HTTP engine reports no target. |
| `headers` | The headers sent, in order, name to value. A name used more than once is an array. Includes the `Cookie`, `Authorization` (preauth) and multipart `Content-Type` headers added by the engine. |
| `params` | A struct with `url` (query string parameters), `form` (form fields), `file` (file parts, name to file name) and `body` (`type`, `length`, `mimetype`, `charset`, never the content). |

Values of `Authorization`, `Proxy-Authorization`, `Cookie` and of any header or parameter whose name contains `password`, `passwd`, `secret`, `token` or `apikey`/`api-key` are replaced with `***`. User info and values of such parameters in `url` and `finalUrl` are masked the same way.

```cfml
cfhttp( url="https://example.org/api?token=abc", method="GET", result="result" );
dump( result.request );
```
