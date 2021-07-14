---
title: <cfmodule>
id: tag-module
related:
- tag-include
categories:
- core
---

Invokes a custom tag for use in cfml templates.

The [[tag-module]] tag can help deal with custom tag name conflicts and differs from the use of [[tag-include]] in that it does not share or affect the scope of the caller.

Use the template attribute to name a template that contains the custom tag definition, including its path.

Individual attributes or an `attributeCollection` may be passed as tag attributes, which will be exclusive to the scope of the module template called.
