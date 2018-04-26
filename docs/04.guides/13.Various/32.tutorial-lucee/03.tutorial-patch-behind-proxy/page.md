---
title: Updating Lucee from behind a proxy
id: tutorial-patch-behind-proxy
---

### Patching Lucee behind a proxy server ###

If you're attempting to update your Lucee server and you're behind a firewall / proxy with restricted outbound access, you can manually download the patch and install yourself.

The patches can always be found at:

http://{dev | preview | www}.getrailo.org/railo/remote/download/{full patch number}/{full patch number}.rc

So, for example, the most recent stable final build is 3.1.2.001 and is found at:

[http://www.getrailo.org/railo/remote/download/3.1.2.001/3.1.2.001.rc](http://www.getrailo.org/railo/remote/download/3.1.2.001/3.1.2.001.rc)

A 3.1.2.020 BER ( Bleeding Edge Release ) would be found:

[http://dev.getrailo.org/railo/remote/download/3.1.2.020/3.1.2.020.rc](http://dev.getrailo.org/railo/remote/download/3.1.2.020/3.1.2.020.rc)

* Please note, it is recommended that you do not patch like this between "major" builds ( e.g.: From 3.1 to 3.1.2 or from 3.1.2 to 3.2 ). It is recommended that you grab the new jar files from getrailo.org

**Installing the patch**

Now, once you have the .rc file downloaded, what do you do with it?

Depending on how your Lucee is setup, you're looking the "/lucee-server/patches" folder. In resin, it can be found {resin install}/lib/lucee-server/patches -- So, if you're on a different JEE engine other than Resin, just look around for your "/lucee-server/patches" folder and drop the .rc file in place.

Once in place, restart the Lucee instance in the server context ( http://{hostname}/lucee-context/admin/server.cfm ). This will drop your current session and you'll have to re-login. When you do, you should be patched to that .rc version.
