---
title: Installing Oracle Java on Windows
id: running-lucee-installing-oracle-java-on-windows
---

![java-logo70x45.jpg](https://bitbucket.org/repo/rX87Rq/images/3132406793-java-logo70x45.jpg)

Java 8 (also known as 1.8) is the current version of Oracle's Java Platform and comes in two flavours:

* Server JRE (Java SE Runtime Environment)
* Java SE Development Kit

Which is the right one for my server?

**Server SE Runtime Environment (Server JRE)** is designed for production servers. It is similar to the desktop JRE but without any GUI, browser integration or auto-update mechanism.

It requires approximately 145MB of disk space.

**Java SE Development Kit (JDK)**  is designed for development servers and includes a complete JRE plus tools for developing, debugging, and monitoring Java applications. Monitoring tools like the cool [Mission Control](http://docs.oracle.com/javacomponents/jmc-5-4/jmc-user-guide/index.html) can help solve problems.  
*Note:* If you plan to use [VisualVM](http://visualvm.java.net/) as your Java monitoring and troubleshooting tool, then the JDK is your choice. It requires approximately 310MB of diskspace.

Installing either the Server JRE or JDK is simple and takes around 10 minutes.

* [Installing the Server JRE](Installing the Server JRE on Windows)
* [Installing the JDK](Installing the JDK on Windows)

- - -

Both packages can be installed on a server without any drawbacks. Switching from one product to the other can be done on the command line:

##  Switch from Server JRE to JDK ##

```
#!DOS
setx JAVA_HOME "" /m
setx JDK_HOME "C:\Program Files\Oracle Java JDK" /m
```

## Switch from JDK to Server JRE ##

```
#!DOS
setx JDK_HOME "" /m
setx JAVA_HOME "C:\Program Files\Oracle Java Server" /m
```

- - -
