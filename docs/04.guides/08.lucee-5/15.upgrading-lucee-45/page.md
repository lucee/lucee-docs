---
title: Upgrading from Lucee 4.5
id: lucee-5-upgrading-lucee-45
---

#Upgrade from Lucee 4.5 (or Railo 4.2)#

1. Stop the servlet engine.
2. Add the lucee.jar you download from [here](http://lucee.org/downloads.html) to "/lib/etc" directory.
3. Remove all other JARs (NOTE you must remove the JARs, DO NOT simply rename them) in the same directory, however *do not* remove the directory "lucee-server" (or "railo-server") if that directory is present, this is the case with default installations.
3. Start the servlet engine.

**Important information**
With Lucee 5 the JARs used by Lucee (except lucee.jar are handled by Lucee and no longer by the servlet engine, these JARs are also bundled with the lucee.jar file).
