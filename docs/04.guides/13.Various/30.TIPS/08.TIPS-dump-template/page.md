---
title: Custom CFDUMP Templates
id: tips-dump-template
related:
- tag-dump
- function-dump
---

### How can I change the default template of CFDump? ###

Open this file: {Lucee installation home}/lucee-server/context/lucee-server.xml

Change where you want default="browser" to be instead:

```lucee
<dump-writers>
        <dump-writer name="html" class="lucee.runtime.dump.HTMLDumpWriter" />
        <dump-writer name="text" class="lucee.runtime.dump.TextDumpWriter" default="console" />
	<dump-writer name="classic" class="lucee.runtime.dump.ClassicHTMLDumpWriter" default="browser" />
        <dump-writer name="simple" class="lucee.runtime.dump.SimpleHTMLDumpWriter" />
</dump-writers>
```
Return to [[faq-s]] or [[tips-and-tricks]]
