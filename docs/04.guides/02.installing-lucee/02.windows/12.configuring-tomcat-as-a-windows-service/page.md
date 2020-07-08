---
title: Configuring Tomcat as a Windows service
id: running-lucee-configuring-tomcat-as-a-windows-service
---

![tomcat-logo65x45.jpg](https://bitbucket.org/repo/rX87Rq/images/3931736055-tomcat-logo65x45.jpg)

Creating the Windows service is only possible on the command line. The basic syntax is:

```
"C:\Program Files\Tomcat\bin\tomcat8.exe" //IS//Tomcat8 --DisplayName="Apache Tomcat Application Server"
```

This line would install the service. The argument **//IS//** installs the service without starting it. Probably the service wouldn't start anyway: A lot of configuration data needs to be stored into the registry first. Actually Tomcat is blind like a mole.

The basic installation from above can be *extended* with configuration data. The installation can be run multiple times in an update mode by using the argument **//US//**. Using multiple runs makes our life easier and we can break down the configuration into logical blocks without losing the global picture.

Let's use this line as the first action to create the service on your server:

```
"C:\Program Files\Tomcat\bin\tomcat8.exe" //IS//Tomcat8 --DisplayName="Apache Tomcat Application Server" --Description="Apache Tomcat Application Server" --Startup="auto"
```

Now we append the path to the **jvm.dll** and the **class path**:

```
"C:\Program Files\Tomcat\bin\tomcat8.exe" //US//Tomcat8 --Classpath="C:\Program Files\Tomcat\bin\bootstrap.jar;C:\Program Files\Tomcat\bin\tomcat-juli.jar"
"C:\Program Files\Tomcat\bin\tomcat8.exe" //US//Tomcat8 --Jvm="C:\Program Files\Oracle Java Server\jre\bin\server\jvm.dll"
```

**Important:** The path to the *jvm.dll* depends, which Java kit you installed previously on your server.
> C:\Program Files\Oracle Java Server\jre\bin\server\jvm.dll  
> C:\Program Files\Oracle Java JDK\jre\bin\server\jvm.dll

Now let's add the remaining **Java Options**:

```
"C:\Program Files\Tomcat\bin\tomcat8.exe" //US//Tomcat8 ++JvmOptions="-Dcatalina.home=C:\Program Files\Tomcat;-Dcatalina.base=D:\Tomcat;-Djava.endorsed.dirs=D:\Tomcat\endorsed;-Djava.io.tmpdir=D:\Tomcat\Temp;-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager;-Djava.util.logging.config.file=D:\Tomcat\conf\logging.properties"
```

Let's continue by adding the **logging** properties:

```
"C:\Program Files\Tomcat\bin\tomcat8.exe" //US//Tomcat8 --LogLevel="Info" --LogPrefix="tomcat_service_" --LogPath="D:\Tomcat\Logs" --StdOutput="auto" --StdError="auto" --PidFile="tomcat8.pid"
```

And finally we add the **Startup** and **Shutdown** properties:

```
"C:\Program Files\Tomcat\bin\tomcat8.exe" //US//Tomcat8 --StartClass="org.apache.catalina.startup.Bootstrap" --StartMode="jvm" ++StartParams="start"  
"C:\Program Files\Tomcat\bin\tomcat8.exe" //US//Tomcat8 --StopClass="org.apache.catalina.startup.Bootstrap" --StopMode="jvm" ++StopParams="stop" --StopTimeout="0"
```

Please check the configuration by starting the Tomcat applet:
> "C:\Program Files\Tomcat\bin\tomcat8w.exe" //ES//Tomcat8

![apache-tomcat-properties-java1.png](https://bitbucket.org/repo/rX87Rq/images/2957749731-apache-tomcat-properties-java1.png)

*Note:* Anything we created is stored the windows registry:
> HKML\SOFTWARE\Wow6432Node\Apache Software Foundation\Procrun 2.0\Tomcat8

- - -
Reference: [Apache Tomcat - Windows Service](http://tomcat.apache.org/tomcat-8.0-doc/windows-service-howto.html)
- - -

## Tomcat runtime configuration ##

One very important thing is left: Tomcat needs to know about his memory configuration and how he should behave in general.

>**Disclaimer: The following values are working well on the authors servers. You can take these settings as a starting point.**
>**These settings are *NOT* an official recommendation of the *Lucee Association Switzerland*.**  

So, stop this shouting and let's get back to business. For this guide, we will use the following values:
> -Xms4096m
> -Xmx4096m  
> -Xss512k
> -XX:NewSize=1024M
> -XX:MaxNewSize=1024M
> -XX:GCTimeRatio=5  
> -XX:ThreadPriorityPolicy=42
> -XX:ParallelGCThreads=4
> -XX:MaxGCPauseMillis=50  
> -XX:+DisableExplicitGC  
> -XX:MaxHeapFreeRatio=70  
> -XX:MinHeapFreeRatio=40  
> -XX:+OptimizeStringConcat
> -XX:+UseTLAB
> -XX:+ScavengeBeforeFullGC
> -XX:CompileThreshold=1500  
> -XX:+TieredCompilation  
> -XX:+UseBiasedLocking  
> -Xverify:none
> -XX:+UseThreadPriorities
> -XX:+UseFastAccessorMethods
> -XX:+UseCompressedOops
> -XX:ReservedCodeCacheSize=256m

Let's apply these settings on the server:

```
"C:\Program Files\Tomcat\bin\tomcat8.exe" //US//Tomcat8 ++JvmOptions="-Xms4096m;-Xmx4096m;-Xss512k;-XX:NewSize=1024M;-XX:MaxNewSize=1024M;-XX:GCTimeRatio=5;-XX:ThreadPriorityPolicy=42;-XX:ParallelGCThreads=4;-XX:MaxGCPauseMillis=50;-XX:+DisableExplicitGC;-XX:MaxHeapFreeRatio=70;-XX:MinHeapFreeRatio=40;-XX:+OptimizeStringConcat;-XX:+UseTLAB;-XX:+ScavengeBeforeFullGC;-XX:CompileThreshold=1500;-XX:+TieredCompilation;-XX:+UseBiasedLocking;-Xverify:none;-XX:+UseThreadPriorities;-XX:+UseFastAccessorMethods;-XX:+UseCompressedOops;-XX:ReservedCodeCacheSize=256m"
```

For you convenience, these command line snippets are available here as a script.

```
set jvm.serverDLL="C:\Program Files\Java\jre8u92\bin\server\jvm.dll"
set catalina.base=D:\Tomcat
set catalina.home=C:\Program Files\Tomcat
set catalina.binary="%catalina.home%\bin\tomcat8.exe"
set catalina.instanceName=Tomcat8
set catalina.displayName="Apache Tomcat Application Server"

%catalina.binary% //IS//%catalina.instanceName% --DisplayName=%catalina.displayName% --Description=%catalina.displayName% --Startup="auto"
%catalina.binary% //US//%catalina.instanceName% --Classpath="%catalina.home%\bin\bootstrap.jar;%catalina.home%\bin\tomcat-juli.jar"
%catalina.binary% //US//%catalina.instanceName% --Jvm=%jvm.serverDLL%
%catalina.binary% //US//%catalina.instanceName% ++JvmOptions="-Dcatalina.home=%catalina.home%;-Dcatalina.base=%catalina.base%;-Djava.endorsed.dirs=%catalina.base%\endorsed;-Djava.io.tmpdir=%catalina.base%\Temp;-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager;-Djava.util.logging.config.file=%catalina.base%\conf\logging.properties"
%catalina.binary% //US//%catalina.instanceName% --LogLevel="Info" --LogPrefix="tomcat_service_" --LogPath="%catalina.base%\Logs" --StdOutput="auto" --StdError="auto" --PidFile="tomcat8.pid"
%catalina.binary% //US//%catalina.instanceName% --StartClass="org.apache.catalina.startup.Bootstrap" --StartMode="jvm" ++StartParams="start"
%catalina.binary% //US//%catalina.instanceName% --StopClass="org.apache.catalina.startup.Bootstrap" --StopMode="jvm" ++StopParams="stop" --StopTimeout="0"
%catalina.binary% //US//%catalina.instanceName% ++JvmOptions="-Xms4096m;-Xmx4096m;-Xss512k;-XX:NewSize=1024M;-XX:MaxNewSize=1024M;-XX:GCTimeRatio=5;-XX:ThreadPriorityPolicy=42;-XX:ParallelGCThreads=4;-XX:MaxGCPauseMillis=50;-XX:+DisableExplicitGC;-XX:MaxHeapFreeRatio=70;-XX:MinHeapFreeRatio=40;-XX:+OptimizeStringConcat;-XX:+UseTLAB;-XX:+ScavengeBeforeFullGC;-XX:CompileThreshold=1500;-XX:+TieredCompilation;-XX:+UseBiasedLocking;-Xverify:none;-XX:+UseThreadPriorities;-XX:+UseFastAccessorMethods;-XX:+UseCompressedOops;-XX:ReservedCodeCacheSize=256m"

```

Now we are ready to start the Tomcat service for the very first time.
