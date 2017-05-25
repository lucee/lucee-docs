---
title: Manually Upgrading Tomcat
id: windows-manually-upgrading-tomcat
---

### Upgrading Tomcat ###

This documentation is intended to cover the process of upgrading Tomcat "by hand". As of Lucee 3.3, the Lucee Installers contain an automatic update process that will trigger if you run the installer and attempt to install to a directory already containing a copy of Lucee. The automatic update process is recommended unless you experience problems with it; in which case these instructions will show you how to perform a manual update so you can obtain access to the latest security and performance enhancements even without the automatic upgrade process.

If you experience problems, please remember to contact Lucee and let us know! That way we can investigate and fix any issues you may encounter.


### Upgrading the Core Libraries ###

The core libraries are the easiest part of Tomcat to update, and generally this is all that's needed in order to take advantage of the latest bug fixes, new features, and security updates. Occasionally, more then just the libraries will need to be updated, but this varies by update, so watch the release notes to see if anything outside the core libraries was updated (like the web applications, windows service, controls, etc).

In order to update the Tomcat libraries, simply take the following steps:

### STEP 1 - Shut Down Lucee/Tomcat ###

It could be problematic to copy over libraries while the server that utilizes them is still running, so we're just going to stop the Lucee/Tomcat server before we proceed with the Tomcat Upgrade:

### STEP 2 - Download and Unzip Tomcat ###

Go to the Tomcat download page: [Tomcat 6 Download Page](http://tomcat.apache.org/download-60.cgi), and download the tomcat core zip file.

Once you download and unzip it, you should see a "lib" directory in the unzipped files:

### STEP 3 - Create a Backup ###

By default, Lucee is installed to C:\lucee\, which means that the tomcat libraries are going to be located in C:\lucee\tomcat\lib. We need to copy the files from the core lib directory that we just downloaded, to the lib directory inside the installed tomcat. Before we do that, it would be wise to copy the C:\lucee\tomcat\lib directory to use as a backup in case anything goes wrong. You can do that by running the following command from the shell:

```lucee
cp C:\lucee\tomcat\lib\ C:\lucee\tomcat\lib-bakup\
```

### STEP 4 - Copy Libraries Over ###

Notice that our current install of Tomcat has two other jars in addition to the jars we will be copying over. These are the MySQL and MS SQL Server database drivers. This means that both MySQL and MS SQL will work "out of the box" when using them in Lucee. You won't want to delete these drivers unless you are upgrading them as well.


### STEP 5 - Start Tomcat and Check Version ###

Start up the Tomcat/Lucee service in the services screen the same way we shut it down, then log in to your tomcat administrator - usually at http://localhost:8888/manager/html/. You will be prompted with your Tomcat username and password. You set up your Tomcat username and password when you installed Lucee via the installer. Once logged in, your Tomcat version number will be located at the bottom-left of the screen.

Have fun and stay secure!


### Applying other Tomcat Updates ###

Occasionally, the Tomcat development team will release updates for features beyond the Tomcat core. The most notable of which are the included applications (like the Tomcat Administrator, Host Manager, etc). To update the included applications, simply copy them over as well. They will be located in the C:\lucee\tomcat\webapps\ROOT\ directory, in both the install and the download.