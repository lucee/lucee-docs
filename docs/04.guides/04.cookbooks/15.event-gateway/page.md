---
title: Event Gateways
id: event-gateways
---

## How does an Event Gateway work? ##

An event gateway is a process which is continuously running. While running, it is doing the following: <cfsleep> for a specific time (the "interval"), then doing what it is designed for (checking changes in a directory, polling a mailserver, etcetera). And after that, it goes to <cfsleep> again. This looping and sleeping does not count for all types of event gateways btw. A socket gateway for example just instantiates a java socket server.

This "doing what it is designed for", will be explained in more detail underneath.

## Which gateways are available ##

Lucee come with 2 gateways: a Directory watcher, and a Mail watcher.

### Directory watcher ###

This event gateway checks a given directory for file changes. These changes (events) can be:

* new files
* changed files
* removed files

When this gateway starts, it first takes a snapshot of the current state of the directory. This is the starting point, from where changes are calculated.

Please note that the files in this first snapshot are NOT seen as changes! So if you already have some files in the directory you want to watch, then these files are not seen as "new file" when the gateway starts. Also, when Lucee (or your whole server) restarts, then any changes which happened within this time are not seen, and will not be picked up when the Directory watcher starts up again.

### Filters ###

You can apply filters for what you exactly want to watch changes for:

* **Watch subdirectories**: same as the "Recurse" option in <cfdirectory> and directoryList()
* **Extensions**: an optional list of comma delimited file extensions. The default is "*", which obviously means "all files".

Note: the Extensions setting might be changed in the near future, due to an enhancement request.

### Mail watcher ###

This gateway checks a given POP mailbox for new mail. Since it only checks for new mail, all emails in the POP box with a date lesser then the startup time will be ignored.

## Location of the gateway files ##

The event gateways are written in CFML! This means you can easily see how they work, and you can also create your own, for example by rewriting the existing ones.

The 2 gateways are located in:

* {Lucee-web}/lucee/gateway/lucee/extension/gateway/DirectoryWatcher.cfc
* {Lucee-web}/lucee/gateway/lucee/extension/gateway/MailWatcher.cfc
* {Lucee-install}/lib/lucee-server/context/gateway/lucee/extension/gateway/DirectoryWatcher.cfc
* {Lucee-install}/lib/lucee-server/context/gateway/lucee/extension/gateway/MailWatcher.cfc

Where {Lucee-web} is the "WEB-INF" directory in your webroot directory (by default), and {Lucee-install} is the Lucee installation directory.

### How to use the Event gateway ###

To use an event gateway, you need to create a "listener cfc". This is a cfc file with some functions, which are called when an event occurs.

You can take the following cfcs as a starting point:

* {Lucee-web}/lucee/gateway/lucee/extension/gateway/DirectoryWatcherListener.cfc
* {Lucee-web}/lucee/gateway/lucee/extension/gateway/MailWatcherListener.cfc

For the Directory watcher, the cfc must have 3 functions: one for each event (new, modified, deleted). The Mail watcher only has one action, and you therefor only need to have one function in your cfc.

You can name these functions anything you like. Just be sure to use the same names when you create the Event gateway.

At the moment, your Listener cfc must be somewhere inside the directory {Lucee-web}/lucee/gateway/ for a gateway created in the web context (via the web admin, or <cfadmin type="web">), and {Lucee-install}/lib/lucee-server/context/gateway/ for a gateway in the server context (created via the server admin, or <cfadmin type="server">).

You might want to check this enhancement request for updates regarding this location requirement.

### Some considerations on creating a listener cfc ###

The CGI scope does not contain useful data. For example, there is no "CGI.http_host".

Debugging can be a bit harder, because there is no Application.cfc/cfm loaded. In fact, since the Event gateway is just one continuously running thread, every iteration of the Event gateway uses the same already loaded listener cfc. If you make any changes to your code, then you will need to stop the gateway, and then restart it. This can be done via the web or server admin.

## Installation ##

After you created your Listener cfc, add it somewhere in the required directory mentioned before.

Then, you can add your gateway instance by using the server/web admin.

Don't forget to change the "Listener CFC Path" to the cfc file you just copied. The path has a dot notation, starting inside the "gateway" directory as mentioned before.

### Example ###

As an example, we will create a Directory listener Event gateway instance. The function of the listener is to copy new incoming files from a directory to a backup directory.

The listener cfc is called "BackupFilesListener.cfc".

We will add this Event gateway into the server admin, because it's functionality is not specifically bound to a website.

First, we create a new directory "{Lucee-install}/lib/lucee-server/context/gateway/backupFilesGateway/", and then copy the CFC inside that directory.

Next, we go to the Lucee server admin, click on "Event gateways (beta)", and add a Directory listener gateway instance

Most of the settings should be self-explanatory. Some comments though...

You can see there is no function name given for the "Delete" action. That's because this example "file backup gateway" does not need to handle file deletions.

The **Listener CFC** Path must be entered using dot notation, starting from within the directory {Lucee-install}/lib/lucee-server/context/gateway/.

The **Interval** and **Watch subdirectory** values should always get your full attention. Remember that the Directory watcher actually does a complete <cfdirectory> crawl on every Interval. So if the directory to check contains a lot of files (and subdirectories, if you checked Watch subdirectory), then the execution of the gateway instance might take some time. The current Interval setting of 10 seconds in this example could also be 100 or 600 seconds, if the files in the directory do not change often, or do not get deleted.

The **function name** of the Change and Add action is the same; they are both called onAdd. It means there is a function onAdd available in BackupFilesListener.cfc. This function will be called on both occasions, which is okay for a functionality that only needs to copy a given file to a certain directory.

## Debugging your gateway implementation ##

First thing to do, is check the Lucee logs. You can find these logs in the following directories:

* {Lucee-install}/lib/lucee-server/context/logs/
* {Lucee-web}/lucee/logs/

You can also view the logs in your web/server admin, by installing the Log Analyzer plugin.

Also, make sure that you wrap your Listener function code inside try-catch blocks, and do something within the catch block. For example:

```lucee
<cffunction name="onAdd" access="public" returntype="void" output="no">
	<cfargument name="fileDetails" type="struct" required="yes" />
	<cftry>
		<---  do your file handling here, for example copy it: --->
		<cffile action="copy" source="#fileDetails.directory##server.separator.file##fileDetails.name#"
			destination="C:/backupfiles/" />
		<cfcatch>
			<cflog log="DirectoryWatcher-errors" type="error" text="Function onChange: #cfcatch.message# #cfcatch.detail#" />
		</cfcatch>
	</cftry>
</cffunction>
```

If you do not add these try-catch blocks, and anything goes wrong, it will be much harder to find out if anything went wrong! For example, the above code would crash if a file with the same name already exists in the directory "C:\backupfiles\".

It might be even wiser to just email the complete error dump, so you will be semi-instantly notified of any errors.

### Using cfadmin with Event gateways ###

Instead of using the server/web admin, you can also use Lucee's <cfadmin> tag. 

Add or update a gateway instance:

```lucee
<cfadmin action="updateGatewayEntry" type="server" password="server-admin-password"
	startupMode="automatic"
	id="copyIncomingFiles"
	class=""
	cfcpath="lucee.extension.gateway.DirectoryWatcher"
	listenerCfcPath="backupFilesGateway.BackupFilesListener"
	custom='#{
		directory="/ftp-root/incoming/"
		, recurse=true
		, interval=10000
		, extensions="*"
		, changeFunction="onAdd"
		, addFunction="onAdd"
		, deleteFunction=""
	}#'
	readOnly=false
/>
```

### Remove a gateway instance: ###

```lucee
<cfadmin action="removeGatewayEntry" type="server" password="server-admin-password"
id="copyIncomingFiles" />
```

## Create your own Event Gateway type ##

[[create-event-gateway]]
