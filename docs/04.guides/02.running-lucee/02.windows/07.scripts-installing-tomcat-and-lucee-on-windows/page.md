---
title: Scripts installing Tomcat and Lucee on Windows
id: running-lucee-scripts-installing-tomcat-and-lucee-on-windows
---

```
#!dos

set catalina.home=C:\Program Files\Tomcat
set catalina.base=D:\Tomcat
set jvm.dir=C:\Program Files\Oracle Java Server
set tomcat.port=8080

set lucee.home=C:\Program Files\Lucee
set lucee.base=D:\Lucee

md "%catalina.home%"
md "%catalina.home%\bin"
md "%catalina.home%\lib"

md %catalina.base%
md %catalina.base%\conf
md %catalina.base%\webapps
md %catalina.base%webapps\host-manager
md %catalina.base%\webapps\manager
md %catalina.base%\webapps\root
md %catalina.base%\endorsed
md %catalina.base%\logs
md %catalina.base%\temp
md %catalina.base%\work

rem Expand the Tomcat files now
pause

"%catalina.home%\bin\tomcat8.exe" //IS//Tomcat8 --DisplayName="Apache Tomcat" --Description="Apache Tomcat" --Startup="auto"
"%catalina.home%\bin\tomcat8.exe" //US//Tomcat8 --Classpath="%catalina.home%\bin\bootstrap.jar;%catalina.home%\bin\tomcat-juli.jar"
"%catalina.home%\bin\tomcat8.exe" //US//Tomcat8 --Jvm="%jvm.dir%\jre\bin\server\jvm.dll"
"%catalina.home%\bin\tomcat8.exe" //US//Tomcat8 ++JvmOptions="-Dcatalina.home=%catalina.home%;-Dcatalina.base=%catalina.base%;-Djava.endorsed.dirs=%catalina.base%\endorsed;-Djava.io.tmpdir=%catalina.base%\Temp;-Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager;-Djava.util.logging.config.file=%catalina.base%\conf\logging.properties"
"%catalina.home%\bin\tomcat8.exe" //US//Tomcat8 --LogLevel="Info" --LogPrefix="tomcat_service_" --LogPath="%catalina.base%\Logs" --StdOutput="auto" --StdError="auto" --PidFile="tomcat8.pid"
"%catalina.home%\bin\tomcat8.exe" //US//Tomcat8 --StartClass="org.apache.catalina.startup.Bootstrap" --StartMode="jvm" ++StartParams="start"  
"%catalina.home%\bin\tomcat8.exe" //US//Tomcat8 --StopClass="org.apache.catalina.startup.Bootstrap" --StopMode="jvm" ++StopParams="stop" --StopTimeout="0"
"%catalina.home%\bin\tomcat8.exe" //US//Tomcat8 ++JvmOptions="-Xms4096m;-Xmx4096m;-Xss512k;-XX:NewSize=1024M;-XX:MaxNewSize=1024M;-XX:GCTimeRatio=5;-XX:ThreadPriorityPolicy=42;-XX:ParallelGCThreads=4;--XX:MaxGCPauseMillis=50;-XX:+DisableExplicitGC;-XX:MaxHeapFreeRatio=70;-XX:MinHeapFreeRatio=40;-XX:+OptimizeStringConcat;-XX:+UseTLAB;-XX:+ScavengeBeforeFullGC;-XX:CompileThreshold=1500;-XX:+TieredCompilation;-XX:+UseBiasedLocking;-Xverify:none;-XX:+UseThreadPriorities;-XX:+UseFastAccessorMethods;-XX:+UseCompressedOops;-XX:ReservedCodeCacheSize=256m"

netsh advfirewall firewall add rule name="Apache Tomcat" dir=in action=allow protocol=TCP localport=%tomcat.port% program="%catalina.home%\bin\tomcat8.exe" profile=ANY

md "%lucee.home%"
md %lucee.base%

rem Expand the Lucee files now
pause

"%catalina.home%\bin\tomcat8.exe" //US//Tomcat8 ++JvmOptions="-javaagent:%lucee.home%\lucee-inst.jar"

```
