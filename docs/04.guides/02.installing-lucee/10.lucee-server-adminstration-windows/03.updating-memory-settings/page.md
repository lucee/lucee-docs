---
title: Updating Memory Settings
id: windows-update-memory-settings
---

As your site grows and your memory needs increase, you will inevitably need to adjust the memory settings for the Lucee Server JVM from it's default setting of 256MB of RAM. For most sites, this is a quite small amount, but it's small by default so that Lucee can be installed successfully on the majority of devices.

When Lucee is implemented using the Windows installer for Lucee, the memory settings of Lucee's JVM are controlled by the _Lucee-Tomcat Service Control_ panel. To access this, find the "Lucee-Tomcat Service Control" icon in your start menu. 

(On some versions of Windows, you must run the service control as the Administrator. To do this simply RIGHT-CLICK the start-menu item, and select "Run As Administrator" from the menu that appears.)

Next, click on the "Java" tab, and edit the min/max JVM heap fields as you see fit. Don't forget to restart Lucee after you make your changes. Please note that you must restart the Lucee service in Windows: if you use the _Restart_ option of the Lucee Server Admin, that will restart the Lucee engine but that would NOT pickup any changes you just made to this _Tomcat-Lucee Service Control_ panel. Restarting the service (or rebooting the box) would pickup such changes.

### Additional JVM Settings ###

The same "Java" tab can be used to pass other parameters to your JVM, such as "-XX:MaxPermSize=128m". Simply add the option to the "Java Options" text area on that same screen. Note that new items should each be added on a new line within that "Java Options" text area, which differs from when providing multiple java arguments via other means.
