---
title: Start and Stopping Lucee
id: windows-start-stop-lucee
---

If you run the Lucee installer, it will create a Windows Service and also enable optional control panels based on the Apache Tomcat on which the installer implemented Lucee. There are then a couple different methods to start or stop the Lucee/Tomcat service on a Windows machine. We'll go over these items here.

While the Tomcat implementation underlying Lucee also offers other ways to start and stop Lucee from the command line (via the lucee\tomcat\bin folder), this documentation is not referring to that. Note also that using that to startup.bat there will NOT use the configuration discussed below regarding the _Lucee-Tomcat Service Control panel_.

### Using Windows Service Controls ###

The Lucee/Tomcat service can be found in the Services control panel, where it can be stopped, started, and otherwise controlled from there. The name of the service may show as "Apache Tomcat 9.0 Lucee", depending on the version of the Lucee installer. 

Note that if you use Windows Task Manager to view services (in its Services tab), Lucee shows by the name "Lucee". (Technically, this Task Manager display shows a service's "Service name" while the Services panel above shows a service's "Display Name", and those can differ.)

### Using the Lucee-Tomcat Service Control panel ###

The installer also implements the _Tomcat Service Control_ panel, which can be opened using the Windows _Start_ Menu, where it's found under `Lucee` as the `Lucee-Tomcat Service Control`.

Once launched the _Tomcat Service Control_ panel also offers the ability to start and stop the Lucee service, but it can also used to customize the Lucee (Tomcat) service settings (such as JVM params). See the "[Updating Memory Settings](lucee-server-adminstration-windows/updating-memory-settings.html)" discussion.

(Beware that if you make a change in in this Lucee-Tomcat Service Control panel, that change only takes effect on a restart of the Lucee service. If you restart Lucee using the Lucee Server Admin's _Restart_ option, that restarts the Lucee engine but does not technically restart the Windows Service for Lucee.)

### Using the Tomcat Service Monitor system tray feature###

The _Tomcat Service Monitor_ is another control panel, which can be opened from the _Start_ Menu for Lucee as `Lucee-Tomcat Service Monitor`. Once enabled, it appears in the Windows System Tray (bottom right corner of your display, by default). You can right-click it to stop/start Lucee, while the "configuration" option launches that _Lucee-Tomcat Service Control_ discussed above.
