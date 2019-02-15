---
title: System Properties
id: running-lucee-system-properties
---

# System properties #
System properties supported by Lucee

* **lucee.base.dir** - base directory for the engine
* **lucee.server.dir** - server context, same as init param lucee-server-directory
* **lucee.web.dir** - web context, same as init param lucee-web-directory
* **lucee.controller.interval** - number of milliseconds between controller calls, 0 to disable controller [useful for benchmark testing etc]
* **lucee.full.null.support** - Turns full null support on or off (true/false)
* **lucee-extensions** - Comma-delimited list of GUID IDs that correspond to extensions Lucee should install automatically
* **lucee.enable.dialect** - Enable the experimental Lucee dialect (true/false)

Find the ID of your extension for the `lucee-extensions` property on this page: [http://preview.lucee.org/download/?type=extensions](http://preview.lucee.org/download/?type=extensions)
