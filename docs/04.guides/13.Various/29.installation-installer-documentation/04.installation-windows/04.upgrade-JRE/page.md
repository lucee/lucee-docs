---
title: Upgrading The JRE
id: windows-upgrade-the-JRE
---

The Java Runtime Environment (JRE) is the environment that your CFML code runs inside of. The Lucee installer ships with a default JRE, but over time this JRE will need to be updated in order to remain stable, secure, and bug free. The following is meant to guide users through the relatively simple process of upgrading the JRE that is running on your Windows Server. Keep in mind that these instructions were written using Windows 2008 R2 64-bit, and may need to be adapted slightly to your own system. For example, if you're running a 32-bit version of Windows, you will need to download the 32-bit JRE.

Keep in mind that your Tomcat software also needs to be updated for security and performance fixes. The easiest way to achieve this is a fresh install of Lucee using the latest [Lucee Installer] (http://download.lucee.org/) which will install and configure the latest versions of Lucee, JRE and Tomcat.

### STEP 1 - Shut Down Lucee/Tomcat ###

It could be problematic to copy over libraries while the server that utilizes them is still running, so we're just going to stop the Lucee/Tomcat server before we proceed with the Tomcat Upgrade:

### STEP 2 - Download the JRE ###

Go to the JRE download page, which at the time of this writing is here: [JRE Download Page](http://www.oracle.com/technetwork/java/javase/downloads/index.html)

Select the Bit Type that's appropriate to your server:

The download link is sort of buried

### STEP 3 - Install the JRE ###

Installing the new JRE requires special attention because in addition to installing a new JRE for Lucee to use, the only method to obtain the JRE will also install a new JRE for your system to use. In a way, this is good because in addition to keeping your Lucee installation up to date, you will also keep your system up to date.

Go ahead and launch the JRE installer that you just downloaded. If you already have a JRE installed on your system, you may get the following warning message - go ahead and click "Yes" to reinstall it:

When you get to the installer part, be sure to click on the checkbox that allows you to customize where you put it. This will make finding the JRE you installed a much easier process:

Click on the "Change" button to choose where you put your JRE.

### STEP 4 - Copy JRE to JDK Directory ###

Now we need to remove the current JRE from Lucee. It should be safe to simply delete what's currently there, and copy over our new JRE files. Go to the C:\lucee\jdk\ directory, and delete everything that's INSIDE that directory. You do NOT want to delete the JDK directory itself, but all the files and directories that are inside it.

When the c:\lucee\jdk\ directory is empty, copy the contents of c:\jre\ to the c:\lucee\jdk directory, so that the contents match:

### STEP 5 - Start Lucee and Test ###

Now go ahead and start the Lucee service back up the same way you stopped it earlier - via the services control. Next, go to the Tomcat Administrator - usually at http://localhost:8888/manager/html/. Log in to the Tomcat administrator using the username and password you created when you installed Lucee. If you do not remember your Tomcat administrator username and password, you can find in in the following file: C:\lucee\tomcat\conf\tomcat-users.xml. Once you're logged in to the Tomcat Administrator, scroll down to the bottom of the page, and Tomcat will report on what JRE number it's running under. If it's the version you just installed, then you're all set!
