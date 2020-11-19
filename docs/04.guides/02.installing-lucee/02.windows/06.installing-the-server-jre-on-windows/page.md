---
title: Installing the server JRE on Windows
id: running-lucee-installing-the-server-jre-on-windows
---

![java-logo70x45.jpg](https://bitbucket.org/repo/rX87Rq/images/1952612483-java-logo70x45.jpg)

First [download the Java 8 Server JRE](https://www.oracle.com/technetwork/java/javase/downloads/server-jre8-downloads-2133154.html).

Choose the **Windows x64** edition. Once downloaded, unzip the content to a temporary folder on your server.

## Installation ##

1. Create the folder **C:\Program Files\Oracle Java Server** on your server.

2. Browse to the expanded content in your temporary folder. Go one level deeper e.g. *jdk1.8.0_XX* (where XX is the current update version) and copy **this** content to the new folder on your server.

Command line:

```
md "C:\Program Files\Oracle Java Server"
xcopy D:\Temp\jdk1.8.0_31\*.* "C:\Program Files\Oracle Java Server" /s
```

(Make sure you change the update version number as appropriate).

## Set JAVA_HOME environment variable

Finally we need to set an environment variable to point to our new Java installation:

1. Open the control panel and choose the *system applet*
2. Click the *Advanced* tab and the button *Environment Variables*
3. Click *New...* at the **System Variables**
4. Use **JAVA_HOME** as the name of the variable and the path **C:\Program Files\Oracle Java Server** as the value.
5. Finish this job by clicking OK until your are back at the control panel.

Or using the command line:

```
setx JAVA_HOME "C:\Program Files\Oracle Java Server" /m
```

To check the environment variable has been set correctly:

1. Open a *new* command prompt, type **set** and hit *enter*
2. Scroll until you see the variable **JAVA_HOME**

## Update ##

It is important to keep Java updated with the latest security patches. To do so, simply *Stop your Tomcat-Service* and repeat the installation steps from above, overwriting the existing files. Don't forget to re-start Tomcat after the update.
