---
title: Starting Tomcat and verifying the installation on Windows
id: running-lucee-starting-tomcat-and-verifying-the-installation-on-windows
related:
- troubleshooting
---

![tomcat-logo65x45.jpg](https://bitbucket.org/repo/rX87Rq/images/1093758943-tomcat-logo65x45.jpg)

## Running Tomcat as a Windows Service

Go to the services applet of the Windows control panel and start the service. Much more cooler is the command line:

```
net start lucee
```

The service name can be configured via the Windows Installer, check the Services Control Panel to confirm.

Congratulations! Your Apache Tomcat is alive. To check if everything is okay, we take a look to the filesystem and the log files.

1. Tomcat should generate log files in the folder **c:\lucee\tomcat\logs**
2. A new folder named *Catalina* plus sub folders should be present underneath **c:\lucee\tomcat\work** and **c:\lucee\tomcat\conf**

Open a browser to access Tomcat's administration interface.

1. For a local access use this URL: `http://localhost:8888`
2. To access the UI from remote, replace *localhost* with the DNS name or IP-Address of your server.
Examples: `http://192.168.100.100:8888`, `http://svlucee01.netfusion.local:8888`

* If you have changed the default port *8888* to something else, then replace 8888 with your chosen port number.
* Accessing the administration interface from *remote* will fail, If you didn't open the Windows firewall.

On the right side of the administration interface, a choice of three pages is available:

1. **Server Status**: An overview about the health and configuration of Tomcat
2. **Manager App**: An overview about the deployed Apps
3. **Host Manager**: Tool to manage hosts

To access these pages, *you need to login* with your previously created account.

- - -

*Tip*: Save this script as a CMD-file to your desktop as a convenient Tomcat restarter:

```
net stop lucee
ping -n 11 127.0.0.1
del c:\lucee\tomcat\logs\*.* /Q
net start lucee
```

## Running Tomcat manually via the command line

In the `tomcat\bin` directory there are `startup.bat` and `shutdown.bat` scripts.

There is also a utility script `catalina.bat` which provides a number of different options

```
c:\lucee\tomcat\bin>catalina
Using CATALINA_BASE:   "c:\lucee\tomcat"
Using CATALINA_HOME:   "c:\lucee\tomcat"
Using CATALINA_TMPDIR: "c:\lucee\tomcat\temp"
Using JRE_HOME:        "C:\Program Files\Eclipse Adoptium\jdk-21.0.6.7-hotspot\"
Using CLASSPATH:       "c:\lucee\tomcat\bin\bootstrap.jar;d:\lucee7\tomcat\bin\tomcat-juli.jar"
Using CATALINA_OPTS:   ""
Usage:  catalina ( commands ... )
commands:
  debug             Start Catalina in a debugger
  jpda start        Start Catalina under JPDA debugger
  run               Start Catalina in the current window
  start             Start Catalina in a separate window
  stop              Stop Catalina
  configtest        Run a basic syntax check on server.xml
  version           What version of tomcat are you running?
```

- The `run` option starts Tomcat in the current console, to stop, use `ctrl-c`.
- The `start` option starts Tomcat in a separate window, similiar to `startup.bat`
- The `jpda start` option starts Lucee with java debugging enabled.