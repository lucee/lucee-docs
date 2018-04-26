---
title: Implementing Log Rotation with Log4j
id: windows-implementing-log-rotation-with-log4j
---

The Lucee Installer does not come with ability to rotate logs built into it. By default, the Lucee installers ship with a version of Tomcat that comes with the default java.util.logging. This is simple and effective logging that will work in most situations, but if you want more complex features, such as rotation based on date or size, you will need to upgrade to a more advanced logging mechanism.

Thankfully, upgrading to log4j is NOT DIFFICULT. Download a couple things here, tweak a config file there, and you're all set.

The following is intended to be a guide on how to go about downloading and installing log4J on a system that was built using the Lucee Installer.

### Review the Tomcat Guide (optional) ###

A lot of what I'm about to write is just a customized form of the Tomcat documentation, which can be found here, if you want to review the original:

[https://tomcat.apache.org/tomcat-7.0-doc/logging.html#Using_Log4j](https://tomcat.apache.org/tomcat-7.0-doc/logging.html#Using_Log4j)

### Installing Log4J Walkthough ###

The following guide will assume you've installed Lucee to the default location of C:\lucee, and the directories stated here will be written accordingly. If you installed Lucee to a different location, you will need to update the example directories to match where you installed Lucee.

Second, I recommend performing this update as the administrator user, because it makes permissions like opening notepad/wordpad much easier to work with. If you're not running as the administrator user, you can generally right-click notepad or wordpad in the start menu and select "Open as Administrator", and then find the file you need to manipulate. It's more of a pain, but it will let you do what you need to here.


### Create the log4j.properties file ###

Start out by creating a standard config file. This config file will force the majority of relevant logging info to be logged in the catalina.out file. When we're done, other log files will be created, but they should not contain any actual information with the exception of a single line on occasion.

Create a new text file in `C:\lucee\tomcat\lib\` called ```log4j.properties```. Make sure it does NOT have the .txt extension! Then add the following text to it:

	# set the log level and name the root logger
	# Available Levels: DEBUG, INFO, WARN, ERROR, FATAL
	log4j.rootLogger=INFO, ROOT

	# set the root logger class
	log4j.appender.ROOT=org.apache.log4j.RollingFileAppender

	# set the name/location of the log file to rotate
	log4j.appender.ROOT.File=${catalina.base}/logs/catalina.out

	# set the max file size before a new file (and backups) are made
	log4j.appender.ROOT.MaxFileSize=150MB

	# set how many iterations of the log file to keep before deleting old logs
	log4j.appender.ROOT.MaxBackupIndex=10

	# set log text formatting
	log4j.appender.ROOT.layout=org.apache.log4j.PatternLayout
	log4j.appender.ROOT.layout.ConversionPattern=%p %t %c - %m%n

	# create a logger for catalina
	log4j.logger.org.apache.catalina=INFO, ROOT

### Download Log4j ###

At the time of this writing, log4j 2.0 beta is available, but since we're (most likely) going to be doing log rotation on production servers, let's use the non-beta version 1.2.17 instead, which can be found in the archived versions here:

[http://archive.apache.org/dist/logging/log4j/1.2.17/](http://archive.apache.org/dist/logging/log4j/1.2.17/)

Extracting this will produce a standard java build directory. To get to the pre-compiled binaries, go to ```dist -> lib```, and you will find ```log4j-1.2.17.jar```. Copy this file to ```C:\lucee\tomcat\lib``` directory, and you're done with this step.

### Download Tomcat Extras ###

There are two additional JAR's Tomcat will need in order to use Log4j, these are tomcat-juli.jar and ```tomcat-juli-adapters.jar``` These are "extras" that the Tomcat project keeps up to date and provides downloads for. You can download these two files from the Tomcat download page, under "Extras":

[http://tomcat.apache.org/download-70.cgi](http://tomcat.apache.org/download-70.cgi)


Once downloaded, you will need to place in the following directories

- tomcat-juli-adapters.jar -> ```C:\lucee\tomcat\lib\```
- tomcat-juli.jar -> ```C:\lucee\tomcat\bin\ (replace the existing file)```

The tomcat-juli.jar that already exists in the tomcat\bin directory has NOT been compiled with log4j support, so it will need to be replaced.

### Set the Context Log Attribute ###

We will need to update the default context config so that logging data is "trapped" and placed in the default root logger. In order to do this, we need to edit the default context file in

	C:\lucee\tomcat\conf\context.xml.

In that file, we need to update this line:

    <Context useHttpOnly="true">

to this:

    <Context useHttpOnly="true" swallowOutput="true">

### Adjusting the Tomcat Service Control ###

By default Tomcat will create some empty files named ```lucee-stderr.[date].log``` and ```lucee-stdout.[date].log``` in the ```C:\lucee\tomcat\logs``` directory. These are created by the Tomcat service control as placeholders for console data. However, since we are redirecting this data to our main catalina.out log file, we don't really need these extra empty files. We can keep the Tomcat Service Control from creating these files by editing the "Logging" tab of the Tomcat Service Control.

Simply replace the values of the "Redirect Stdout:" and "Redirect Stderr:" to nothing and the service control will not create these files.

### Cleanup and Restart ###

Last, we need to remove the previous logging.properties file as Tomcat will still read that and create empty log files if we do not remove it. Just delete it or rename it if you want to keep it around for some reason.

I would also recommend that you clean out the previous logs from the ```C:\lucee\tomcat\logs\``` directory. To do this, just stop the Tomcat service, delete the logs, then start it again. This will make verifying your config much easier, as you can see at a glance if your new logging config has taken effect.

### Verify Your Config ###

Once you've restarted Tomcat. Check your log directory and ensure that the bulk of the log data is now being stored in your catalina.out file. An example resulting config can be seen in the image below.

Note that while other files have indeed been created, there is nothing useful in them, as all useful log data is being directed to the catalina.out file.
