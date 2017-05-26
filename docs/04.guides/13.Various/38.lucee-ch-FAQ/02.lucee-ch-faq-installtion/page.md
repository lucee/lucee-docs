---
title: Installation
id: lucee-ch-faq-installtion
---

### Questions about the installation of Lucee ###

**How do I apply a patch to my current Lucee Version?**

Just navigate to the Server Admin (/lucee-context/admin/server.cfm) and choose the menu entry "Services/Update". There you have the ability to download and install patches or to uninstall them if desired.

**How do I know which engine answers a request when having installed more than one engine on a server?**

The easiest way to achieve that is, by calling a CFM file that is not present in a webroot. The error message displayed should inform you of which engine you are currently requesting. This solution only works, if you do not us any special 404 error template. In this case just try out the different URL's of the engine's administrators.

**I have installed Lucee Server. Why is no login mask appearing, when I call the administrator's address?**

By default in the Resin configuration Resin (as the web application server) is installed on port 8600. A call in a browser of http:localhost/lucee-context/admin/web.cfm results in an error since it is querying port 80 (by default). You have two possibilities in order to fix this problem. You can either change the port where Resin listens for requests in the file resin.conf from 8600 to 80 and try again, or you use the URL http:localhost:8600/lucee-context/admin/web.cfm. Please note that with the Internet Explorer you always have to enter the protocol as well (http://) since he otherwise does not understand this request. Firefox and other browsers are a little more cunning.

**How can I install Lucee under Linux?**

If you want to use the Lucee Express version for testing purposes, just unpack the corresponding zip/tar.gz-file and execute the file start.sh. After this you should be able to access Lucee on port 8888 with the link [http://localhost:8888/index.cfm](https://web.archive.org/web/20090129164442/http://localhost:8888/index.cfm)
If, on the other hand, you would like to do a server installation, just read the following [installation guide](https://web.archive.org/web/20090129164442/http://railo.ch:80/railo/documentation/InstallGuide_Lucee_Resin_Apache_Linux.pdf).

**Can Lucee be instantiated more than once?**

Since Lucee is a regular web application, it can of course be instantiated in several web-contextes. This means that it can run more than once even in different versions on a servlet engine. Read more here.

**Which servlet engines can execute Lucee?**

Lucee was tested successfully with the following engines:

* Resin 3.1.x
* Jetty 4.2.19
* Tomcat 5.x
* JBoss 4.0.x

But there is nothing that keeps Lucee from running on any other standard servlet engine. But only the above engines have been tested by us.

**What operating system does Lucee require?**

Lucee runs on every System where a Servlet Engine is available for

**How do I Update my current version?**

Updates can not be installed with the help of the Server Admin (see above), since they most likely contain adjustments to the public interface.

If you have installed "Lucee Server" with the help of the "exe" version, You can execute the newer "exe" which will install everything over the older one. The installation routine will recognize the older version and updates it accordingly. 

All other versions can be updated manually. Just copy the contents of the File "lucee-*.*.*.*-jars.zip" into your lib directory and restart Lucee.
Lib directories:

* Lucee Server: {lucee-server}/lib/
* Lucee Express: {lucee-express}/extra/lib/

**Do I have to install Lucee in order to test it?**

No, you can use the Lucee Express version exactly for this purpose. Just unpack it into a certain folder and start developing.

This version is well suited to test own written applications.

**Can I only use the datasource types listed in the web administrator Drop-Down?**

No, on one hand you can use any JDBC-driver by choosing other in the database type Drop-Down and provide the class of the used database driver. And on the other hand you can enlarge the Drop-Down by implementing your own driver. This has to be done like follows: In the folder /WEB-INF/lucee/context/admin/dbdriver/ the drivers for the available datasource types are located in a cfc. Just copy one of these drivers and customize it the way you need it. All drivers inherit the component driver.cfc, located in this directory ,too. Ask us, if you're looking for a certain driver. We will be glad to help you.
