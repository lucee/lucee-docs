---
title: Installing the JDK on Windows
id: running-lucee-installing-the-jdk-on-windows
---

![java-logo70x45.jpg](https://bitbucket.org/repo/rX87Rq/images/398847305-java-logo70x45.jpg)

First download the current [Java 8 SE Development Kit](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html).

Choose the **Windows x64** edition and save it to a temporary folder on your server.

## Installation ##

1. Create the folder **C:\Program Files\Oracle Java JDK** on your server.
2. Start the installer by double-clicking the downloaded .exe file.
3. Click *Next*. Select **Development Tools** and set the "Install to..." location to be the folder you created above.
4. Untick **Source Code** and **Public JRE**. We don't need these.
5. Click *Next* to start installing.

![java-jdk-setup.png](https://bitbucket.org/repo/rX87Rq/images/252239566-java-jdk-setup.png)

## Set JDK_HOME Environment variable

Finally we need to set an environment variable to point to our new Java installation:

1. Open the control panel and choose the *system applet*
2. Click the *Advanced* tab and the button *Environment Variables*
3. Click *New...* at the **System Variables**
4. Use **JDK_HOME** as the name of the variable and the path **C:\Program Files\Oracle Java JDK** as the value.
5. Finish by clicking OK until your are back at the control panel.

Or using the command line:

```
setx JDK_HOME "C:\Program Files\Oracle Java JDK" /m
```

To check the environment variable has been set correctly:

1. Open a *new* command prompt, type **set** and hit *enter*
2. Scroll until you see the variable **JDK_HOME**

## Update ##

It is important to keep Java updated with the latest security patches. To do so simply download the latest installer, *Stop your Tomcat-Service* and install the new version over the old one. Don't forget to re-start Tomcat after the update.

## Silent Installation ##

If you need to install this product on several servers then a silent installation will make your life easier:

```
jdk-8u31-windows-x64.exe /s addlocal="ToolsFeature" installdir="C:\Program Files\Oracle Java JDK"
setx JDK_HOME "C:\Program Files\Oracle Java JDK" /m
```

(Make sure you change the update version number as appropriate).
---
