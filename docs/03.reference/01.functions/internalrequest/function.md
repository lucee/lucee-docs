---
title: internalRequest
id: function-internalrequest
related:
- tag-http
categories:
- protocols
- server
---

Makes a request to the CFML Engine internally. also available in 5.x as _internalRequest()

Great for CI / tests, internalRequest allows you to call another cfml page on the same server without needing to make an http call

## The `template` argument

The `template` is a path to a CFML template on the same server.

- A path **with** a leading slash is resolved from the root, from the web root and the mappings, for example `/app/index.cfm`.
- A path **without** a leading slash is relative to the directory of the template that calls the function, like in `cfinclude`. `./` and `../` are supported, for example `index.cfm`, `sub/index.cfm` or `../index.cfm`. The directory is taken from the virtual path of the caller, so it works for templates that are found through a mapping.
- A relative path that goes above the root with `../` throws an exception.

**Breaking change in Lucee 9.0** ([LDEV-4038](https://luceeserver.atlassian.net/browse/LDEV-4038)): before Lucee 9.0 a path without a leading slash was resolved from the root. Add the leading slash to such calls, see [[breaking-changes-8-0-to-9-0]].

