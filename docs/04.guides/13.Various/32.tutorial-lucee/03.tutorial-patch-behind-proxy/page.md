---
title: Updating Lucee from behind a proxy
id: tutorial-patch-behind-proxy
---

### Patching Lucee behind a proxy server ###

If you're attempting to update your Lucee server and you're behind a firewall / proxy with restricted outbound access, you can manually download the patch and install yourself.

The patches can always be found at:

https://cdn.lucee.org/{version number}.lco

So, for example, the most recent stable final build is 5.2.9.31 and is found at:

[https://cdn.lucee.org/5.2.9.31.lco](https://cdn.lucee.org/5.2.9.31.lco)

* Please note, it is recommended that you do not patch like this between "major" builds ( e.g.: From 5.1 to 5.1.2 or from 5.1.2 to 5.2 ). It is recommended that you use JAR files from [https://download.lucee.org](https://download.lucee.org)

**Installing the patch**

Now, once you have the .rc file downloaded, what do you do with it?

Depending on how your Lucee is setup, you're looking the "/lucee-server/patches" folder. In resin, it can be found {resin install}/lib/lucee-server/patches -- So, if you're on a different JEE engine other than Resin, just look around for your "/lucee-server/patches" folder and drop the .rc file in place.

Once in place, restart the Lucee instance in the server context ( http://{hostname}/lucee/admin/server.cfm ). This will drop your current session and you'll have to re-login. When you do, you should be patched to that .rc version.
