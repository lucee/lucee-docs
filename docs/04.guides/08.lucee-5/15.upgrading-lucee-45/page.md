---
title: Upgrading from Lucee 4.5
id: lucee-5-upgrading-lucee-45
---

#Upgrade from Lucee 4.5#

1. Stop the servlet engine
2. Go to the Lucee website to the [download page](http://lucee.org/downloads.html), download "Custom/JARs" and unzip the downloaded zip file somewhere on your system.
3. Add lucee.jar and org-apache-felix-main-x-x-x.jar (x-x-x stands for a specific version) to "/lib/etc" from the download and remove all other jars in that directory, but do not remove the directory "lucee-server" if that directory is present there, which is the case with default installations.
4. If you have not defined a "railo-server-directory" in your servlet specification, add the rest of the jars you have downloaded to "{servlet-engine}/lucee-server/bundles/" (you will need to create these folders). If you have defined a "railo-server-directory" with your servlet specification copy the jars to "{your-path}/bundles"
5. Start the servlet engine

**Important information!**
With Lucee 5 the JARs used by Lucee (except lucee.jar and org-apache-felix-main-x-x-x.jar) are handled by Lucee and no longer by the servlet engine. It is therefore important that the servlet engine does not load the jars you added in point #4.
Therefore they should not be in the servlet engines classpath, for example not inside the lib folder.
