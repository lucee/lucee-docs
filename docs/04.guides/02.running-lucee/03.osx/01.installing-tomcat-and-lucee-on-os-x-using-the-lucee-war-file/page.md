---
title: Installing Tomcat and Lucee on Mac OS X using the Lucee WAR file
id: running-lucee-installing-tomcat-and-lucee-on-os-x-using-the-lucee-war-file
---

Download a copy of Apache Tomcat 7 core, available at the [Tomcat download page](http://tomcat.apache.org/download-70.cgi).

Install Tomcat by extracting the downloaded archive. Extract the archive to your home folder, /Users/<username>. For convenience, you can rename the resulting folder from //apache-tomcat-7.0.59// to //tomcat//.

1. Go into //./tomcat/webapps///. Delete the //ROOT// folder and //ROOT.war//.

2. Next, go to the [Lucee download page](https://bitbucket.org/lucee/lucee/downloads) and download the latest lucee war file.

3. Rename the lucee war file to //ROOT.war// (note the capitalization).

4. Copy the renamed //ROOT.war// file into //./tomcat/webapps//.

5. Create a directory called //lucee// in //./tomcat//.

6. Extract the contents of //ROOT.war//.

7. Go into  //./tomcat/webappsROOT/WEB-INF/lib// and copy everything in that folder to //./tomcat/lucee//.

8. Go into //./tomcat/bin//.
​

9. Create a file called //setenv.sh//. Tomcat uses this file to set environment variables on startup. Open the file and add this line:

```
JAVA_OPTS="-Xms256m -Xmx1024m -XX:MaxPermSize=128m  -javaagent:${CATALINA_HOME}/lucee/lucee-inst.jar";
```

10. Go into //./tomcat/conf//.

11. Open //catalina.properties//. Replace the commented line in this text with the new line:

```
#common.loader=${catalina.base}/lib,${catalina.base}/lib/*.jar,${catalina.home}/lib,${catalina.home}/lib/*.jar
common.loader=${catalina.home}/lib,${catalina.home}/lib/*.jar,${catalina.home}/lucee,${catalina.home}/lucee/*.jar
```

12. Open a Terminal prompt. Follow these commands:

```
$ cd tomcat/bin
$ chmod 775 *
$ ./startup.sh
```

13. Next, open a web browser to localhost:8080/lucee/admin/web.cfm. You should see the Lucee Web admin login screen. Lucee is now installed.

**Next Steps**

From this point you can configure your Tomcat instance and set up your applications in Lucee.
