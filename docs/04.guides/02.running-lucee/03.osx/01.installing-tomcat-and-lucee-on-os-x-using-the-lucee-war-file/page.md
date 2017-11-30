---
title: Installing Tomcat and Lucee on Mac OS X using the Lucee WAR file
id: running-lucee-installing-tomcat-and-lucee-on-os-x-using-the-lucee-war-file
---

Download a copy of Apache Tomcat 7 core, available at the [Tomcat download page](http://tomcat.apache.org/download-70.cgi).

Install Tomcat by extracting the downloaded archive. Extract the archive to your home folder, /Users/<username>. For convenience, you can rename the resulting folder from //apache-tomcat-7.0.59// to //tomcat//.

1. Go into tomcat/webapps/. Delete the /ROOT/ folder and /ROOT.war/.

2. Next, go to the [Lucee download page](http://lucee.org/downloads.html) and download the latest lucee war file.

3. Rename the lucee war file to /ROOT.war/ (note the capitalization).

4. Copy the renamed /ROOT.war/ file into tomcat/webapps/.

13. Next, open a web browser to localhost:8080/lucee/admin/web.cfm. You should see the Lucee Web admin login screen. Lucee is now installed.

**Next Steps**

From this point you can configure your Tomcat instance and set up your applications in Lucee.
