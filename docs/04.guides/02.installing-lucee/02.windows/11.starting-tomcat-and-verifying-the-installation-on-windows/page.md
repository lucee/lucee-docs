---
title: Starting Tomcat and verifying the installation on Windows
id: running-lucee-starting-tomcat-and-verifying-the-installation-on-windows
---

![tomcat-logo65x45.jpg](https://bitbucket.org/repo/rX87Rq/images/1093758943-tomcat-logo65x45.jpg)

Go to the services applet of the Windows control panel and start the service. Much more cooler is the command line:


```
net start tomcat8
```

Congratulations! Your Apache Tomcat is alive. To check if everything is okay, we take a look to the filesystem and the log files.

1. Tomcat should generate log files in the folder **D:\Tomcat\logs**
2. A new folder named *Catalina* plus sub folders should be present underneath **D:\Tomcat\work** and **D:\Tomcat\conf**

Open a browser to access Tomcat's administration interface.

1. For a local access use this URL: http://localhost:8080
2. To access the UI from remote, replace *localhost* with the DNS name or IP-Address of your server.
Examples: http://192.168.100.100:8080, http://svlucee01.netfusion.local:8080

* If you have changed the default port *8080* to something else, then replace 8080 with your chosen port number.
* Accessing the administration interface from *remote* will fail, If you didn't open the Windows firewall.

On the right side of the administration interface, a choice of three pages is available:

1. **Server Status**: An overview about the health and configuration of Tomcat
2. **Manager App**: An overview about the deployed Apps
3. **Host Manager**: Tool to manage hosts

To access these pages, *you need to login* with your previously created account.

- - -

*Tip*: Save this script as a CMD-file to your desktop as a convenient Tomcat restarter:

```
net stop Tomcat8
ping -n 11 127.0.0.1
del D:\Tomcat\Logs\*.* /Q
net start Tomcat8
```
