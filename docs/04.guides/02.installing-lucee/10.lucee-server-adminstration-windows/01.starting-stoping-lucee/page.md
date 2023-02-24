---
title: Start and Stopping Lucee
id: windows-start-stop-lucee
---

If you run the Lucee installer, it will create a Windows Service and also enable optional control panels based on Apache Tomcat which is implemented by the Lucee installer. There are then a couple different methods to start or stop the Lucee/Tomcat service on a Windows machine. We'll go over these items here.

While the Tomcat implementation underlying Lucee also offers other ways to start and stop Lucee from the command line (via the lucee\tomcat\bin folder), this documentation is not referring to that. Note in particular that using that to startup.bat there will NOT use the configuration discussed below regarding the _Lucee-Tomcat Service Control panel_.

### Using Windows Service Controls ###

The Lucee/Tomcat service can be found in the Services control panel, where like any Windows service it can be stopped, started, and otherwise controlled from there. The name of the service may show as "Apache Tomcat 9.0 Lucee", depending on the version of the Lucee installer. 

Note that if you use _Windows Task Manager_ to view services (in its _Services_ tab), Lucee appears with the name "Lucee". (Technically, this Task Manager display shows a service's _Service name_ while the Services panel above shows a service's _Display Name_, and those can differ based on how the service was created.)

### Using the Lucee-Tomcat Service Control panel ###

The Lucee installer also implements the _Tomcat Service Control_ panel, which can be opened using the Windows _Start_ Menu, where it's found under `Lucee` as the `Lucee-Tomcat Service Control`.

Once launched, the _Tomcat Service Control_ panel also offers the ability to start and stop the Lucee service, but it can also used to customize the Lucee (Tomcat) service settings (such as JVM params). See the "[Updating Memory Settings](../03.updating-memory-settings/page.md)" discussion elsewhere in this Windows Administration section of the docs.

(Beware that if you make a change in this _Lucee-Tomcat Service Control_ panel, that change only takes effect on a restart of the Lucee _service_. If instead you restart Lucee using the Lucee Server Admin's _Restart_ option, that will restart the Lucee engine but does not technically restart the Windows Service for Lucee, so would NOT see changes you made in the control panel. Always restart the Lucee service using one of the two options discussed above, if you change any configuration settings in that _Lucee-Tomcat Service Control_ panel.)

### Using the Tomcat Service Monitor system tray feature ###

The _Tomcat Service Monitor_ is another feature which can be opened from the _Start_ Menu for Lucee as `Lucee-Tomcat Service Monitor`. Once enabled, it appears in the Windows System Tray (bottom right corner of your display, by default). You can right-click it to stop/start Lucee, and the "configuration" option launches that _Lucee-Tomcat Service Control_ discussed above.