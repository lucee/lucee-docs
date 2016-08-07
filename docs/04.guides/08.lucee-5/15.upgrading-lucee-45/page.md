---
title: Upgrading from Lucee 4.5
id: lucee-5-upgrading-lucee-45
---

# Upgrade from Lucee 4.5 (or Railo 4.2)

To upgrade your existing Lucee 4.5 (or Railo 4.2) install to Lucee 5 please follow the following instructions:

1. Download the `lucee-5.x.x.xxx.jar` from http://lucee.org/downloads.html.
2. Stop the servlet engine on your server, this is normally Apache Tomcat, however if you have a custom install it might differ. (Ubuntu: `sudo service lucee_ctl stop`. Windows: `net stop Lucee`.)
3. Add the `lucee-5.x.x.xxx.jar` you downloaded to the "lib" directory in your existing Lucee install.
4. Remove all other JARs in the same directory, however *do not* remove the directory "lucee-server" (or "railo-server") if that directory is present, this is the case with default installations. *Please note* you must remove the JARs, *DO NOT* simply rename them.
5. Start the servlet engine. (Ubuntu: `sudo service lucee_ctl start`. Windows: `net start Lucee`.)

## Important information

1. With Lucee 5 the JARs used by Lucee, except lucee.jar are handled by Lucee and no longer by the servlet engine and these JARs are also bundled with the lucee.jar file.
2. Loading the `lucee-inst.jar` javaagent is no longer necessary and should be removed from your JVM arguments if you have it in place. (This could be in your Lucee dir at `tomcat/bin/setenv.sh` on *nix or `tomcat/bin/service.bat` on Windows.)
