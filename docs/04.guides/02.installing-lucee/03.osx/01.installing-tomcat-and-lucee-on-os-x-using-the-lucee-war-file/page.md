---
title: Installing Tomcat and Lucee on Mac OS X using the Lucee WAR file
id: running-lucee-installing-tomcat-and-lucee-on-os-x-using-the-lucee-war-file
---

Download a copy of Apache Tomcat 8.5 core, available at the [Tomcat download page](https://tomcat.apache.org/download-80.cgi).

Install Tomcat by extracting the downloaded archive. Extract the archive to your home folder, /Users/<username>. For convenience, you can rename the resulting folder from //apache-tomcat-8.5.29// to //tomcat//.

1. Go into tomcat/webapps/. Delete the /ROOT/ folder and /ROOT.war/.

2. Next, go to the [Lucee download page](http://lucee.org/downloads.html) and download the latest lucee war file.

3. Rename the lucee war file to /ROOT.war/ (note the capitalization).

4. Copy the renamed /ROOT.war/ file into tomcat/webapps/.

5. Next, open a web browser to localhost:8080/lucee/admin/web.cfm. You should see the Lucee Web admin login screen. Lucee is now installed.

6. You may want to install [mod_cfml](https://viviotech.github.io/mod_cfml/install-lin-ubuntu.html) to use Apache

**Next Steps**

From this point you can configure your Tomcat instance and set up your applications in Lucee.
