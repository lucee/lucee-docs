---
title: Installing Apache Tomcat on Windows
id: running-lucee-installing-apache-tomcat-on-windows
---

Since this article was first written, Lucee has a [Windows Installer](https://download.lucee.org/?type=releases) which installs Tomcat with Lucee.

![tomcat-logo65x45.jpg](https://bitbucket.org/repo/rX87Rq/images/1093758943-tomcat-logo65x45.jpg)

Before we start with the installation, we need to dive into some basics:

## What we don't like ##
* A mix of binaries (exe, dll-files) and configuration data (eg. xml files) in the *application directory*
* The software needs **change permissions** to write data into his *application directory*
* A windows service needs **System Authority** permissions

## What we really like ##
* The application can live perfectly with **read permissions** in its *application directory*
* The data of the application can be stored in a *data directory* on a different drive as C-drive
* A windows service can run with a **low privileged** user permissions

This guide will  fully cover a setup of Apache Tomcat to fullfill these goals from *What we really like* above.

In terms of Apache Tomcat, we split the files by setting Tomcat's main variables to the **Application path** and **Data path** later on:

> catalina.home=C:\Program Files\Tomcat  
> catalina.base=D:\Tomcat

Before we start, let's download Apache Tomcat from this page: [Tomcat 8 Downloads](http://tomcat.apache.org/download-80.cgi). Scroll down a bit and choose the link ***64-bit Windows zip***. Download the product and unzip the content to a temporary folder on your server.

## Installation ##
1. Create the folders **C:\Program Files\Tomcat**, **C:\Program Files\Tomcat\bin** and **C:\Program Files\Tomcat\lib**
2. Browse the expanded content in your temporary folder and change into the folder **apache-tomcat-8.0.18**.
3. Copy the five files from the root in to the folder **C:\Program Files\Tomcat**
4. Goto the folder named *bin*.
5. Copy all files, except  *\*.bat*, *\*.gz* and *\*.sh* to the folder **C:\Program Files\Tomcat\bin**. We don't need the batch files: The Tomcat service will get his configuration from the Windows registry instead.
6. Go back one level and goto to the folder named *lib*
7. Copy all files to the folder **C:\Program Files\Tomcat\lib**

That's it, at least for the application folder. Tomcat requires approximately 10MB of diskspace.

Command line:

```
md "C:\Program Files\Tomcat"
copy D:\temp\apache-tomcat-8.0.18\*.* "C:\Program Files\Tomcat" /Y

md "C:\Program Files\Tomcat\bin"
copy D:\temp\apache-tomcat-8.0.18\bin\*.exe "C:\Program Files\Tomcat\bin" /Y
copy D:\temp\apache-tomcat-8.0.18\bin\*.dll "C:\Program Files\Tomcat\bin" /Y
copy D:\temp\apache-tomcat-8.0.18\bin\*.jar "C:\Program Files\Tomcat\bin" /Y
copy D:\temp\apache-tomcat-8.0.18\bin\*.xml "C:\Program Files\Tomcat\bin" /Y

md "C:\Program Files\Tomcat\lib"
copy D:\temp\apache-tomcat-8.0.18\lib\*.jar "C:\Program Files\Tomcat\lib" /Y
```

Note: You can paste the content of the container above directly into the command line of the server.

Now lets do the same for the configuration and data folder:

1. Create the folders: **D:\Tomcat**, **D:\Tomcat\conf** and **D:\Tomcat\webapps**.
2. Goto the folder named *conf*.
3. Copy all files to the folder **D:\Tomcat\conf**
4. Create the folders **D:\Tomcat\webapps\host-manager**, **D:\Tomcat\webapps\manager** and **D:\Tomcat\webapps\ROOT**.
5. Goto the folder named *webapps*.
6. Copy the folders *host-manager*, *manager* and *ROOT* to the matching folder on the target. All these folders have subfolders.
7. Create the folders **D:\Tomcat\logs**, **D:\Tomcat\endorsed**, **D:\Tomcat\temp** and **D:\Tomcat\work**. Some of these directories remain empty until the very first start of Tomcat.

Command line:

```
md D:\Tomcat
md D:\Tomcat\conf
copy D:\temp\apache-tomcat-8.0.18\conf\*.* D:\Tomcat\conf /Y

md D:\Tomcat\webapps
md D:\Tomcat\webapps\host-manager
xcopy D:\temp\apache-tomcat-8.0.18\webapps\host-manager\*.* D:\Tomcat\webapps\host-manager /s /Y
md D:\Tomcat\webapps\manager
xcopy D:\temp\apache-tomcat-8.0.18\webapps\manager\*.* D:\Tomcat\webapps\manager /s /Y
md D:\Tomcat\webapps\ROOT
xcopy D:\temp\apache-tomcat-8.0.18\webapps\ROOT\*.* D:\Tomcat\webapps\ROOT /s /Y

md D:\Tomcat\endorsed
md D:\Tomcat\logs
md D:\Tomcat\temp
md D:\Tomcat\work
```

We finished the basic installation. Now we have to edit some of the configuration files.  
Let's go to the folder **D:\Tomcat\conf**.

## server.xml##

Catalina's default host needs some tweaking. Find the line:

```xml
<Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
```

Change this line to:

```xml
<Host name="localhost" appBase="D:\Tomcat\webapps" workDir="D:\Tomcat\work\Catalina\localhost" unpackWARs="true" autoDeploy="true">
```

A few lines below, you will find the line:

```xml
<Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
```
We need to specify the full path to the log directory:

```xml
<Valve className="org.apache.catalina.valves.AccessLogValve" directory="D:\Tomcat\logs"
```

The next step is optional. Tomcat and Lucee are listening on port **8080** to access the administrator interface. Other web servers might use this port already or if you suffer from a security paranoia like i do, we want to have this port on a *really weard number*.  

*Note:* The Lucee'ians are used to have port **8888** to access the administrator interface.

Find the setting:

```xml
<Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
```

Change the port *8080* to the new port.  

If you like to access the Tomcat Administration from outside of the server, the Windows firewall needs to be opened with a rule:

```
netsh advfirewall firewall add rule name="Apache Tomcat" dir=in action=allow protocol=TCP localport=8888 program="C:\Program Files\Tomcat\bin\tomcat8.exe" profile=ANY
```

You don't like the command prompt? Add the rule with the firewall applet in the control panel.
Be sure, that the port is limited to the main exe file **C:\Program Files\Tomcat\bin\tomcat8.exe**.

> Todo: maxHttpHeaderSize="8192" (Default: 4096)
             minSpareThreads="25" (Default: 4)
             disableUploadTimeout="true" (Default: false)

## tomcat-users.xml##

This file holds rules, usernames and passwords to access the administrator interface of Tomcat. The access to the administrator interface is disabled by default:


```xml
<!--
  <role rolename="tomcat"/>
  <role rolename="role1"/>
  <user username="tomcat" password="tomcat" roles="tomcat"/>
  <user username="both" password="tomcat" roles="tomcat,role1"/>
  <user username="role1" password="tomcat" roles="role1"/>
-->
```

Replace the content with this:

```xml
<role rolename="admin-gui"/>
<role rolename="manager-gui"/>
<user name="AccountName" password="VeryStrongPassword" roles="admin-gui,manager-gui" />
```

Choose a clever name for the administrator account. For security reasons, do not choose *admin* oder *administrator*!
The password should contain a mix between upper- and lower-case letters, numbers and special characters like _-!.

## catalina.properties ##

This is an optional task, which cuts the time Tomcat takes to start:

Find the line:

```
tomcat.util.scan.StandardJarScanFilter.jarsToSkip=\
```
Remove the lines below until the next comment and change the line to:

```
tomcat.util.scan.StandardJarScanFilter.jarsToSkip=\*.jar
```
Instead of skipping the list of JAR's at startup, Tomcat will skip all JAR's.

Find the line:

```
tomcat.util.scan.StandardJarScanFilter.jarsToScan=log4j-core*.jar,log4j-taglib*.jar
```

Add a **remark** in front of the line:

```
#tomcat.util.scan.StandardJarScanFilter.jarsToScan=log4j-core*.jar,log4j-taglib*.jar
```

##Update##

An minor update requires mostly only the replacement of the files in the folders **C:\Program Files\Tomcat\bin** and **C:\Program Files\Tomcat\lib**. Stop the Tomcat service, replace the files and start the service. That's it.

- - -
Reference: [Tomcat Configuration Reference](http://tomcat.apache.org/tomcat-8.0-doc/config/systemprops.html)
- - -
