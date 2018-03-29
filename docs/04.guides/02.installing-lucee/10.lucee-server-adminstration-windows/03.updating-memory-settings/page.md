---
title: Updating Memory Settings
id: windows-update-memory-settings
---

As your site grows and your memory needs increase, you will inevitably need to adjust the memory settings for the Lucee Server JVM from it's default setting of 256MB of RAM. For most sites, this is quite small, but it's small by default so that it can be installed successfully on the majority of devices.

The memory settings of Lucee's JVM is controlled by the Tomcat Service Control. To access the Lucee/Tomcat service control, find the "Lucee-Tomcat Service Control" icon in your start menu. On some OS's, like Windows 7, you have to run the service control as the Administrator. To do this simply RIGHT-CLICK the start-menu item, and select "Run As Administrator" from the menu that appears.

Next, click on the "Java" tab, and edit the min/max JVM heap fields as you see fit. Don't forget to restart Lucee after you make your changes.

### Additional JVM Settings ###

The same "Java" tab can be used to pass other parameters to your JVM, such as "-XX:MaxPermSize=128m". Simply add the option to the "Java Options" text area on that same screen.