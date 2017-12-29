---
title: Create your own Event Gateway type
id: create-event-gateway
---


### Preface ###


Here you will find a short introduction into writing your own Event Gateway type. Since you can write these in pure cfml (and java when you want it), it is really simple to do.
There are 2 to 3 files you need to create:

* the Gateway cfc
* the Gateway Driver cfc
* A listener cfc

### The Gateway CFC ###

This is the file which contains the action you want your gateway to do. Also, it is the file which is instantiated by Lucee when the gateway starts.

You can take the following files as an example:

* {Lucee-install}/lib/lucee-server/context/gateway/lucee/extension/gateway/DirectoryWatcher.cfc
* {Lucee-install}/lib/lucee-server/context/gateway/lucee/extension/gateway/MailWatcher.cfc

The example code shown underneath is a modified version of the DirectoryWatcher.cfc, which, at time of writing, is in line for reviewing at the Lucee team.
By default, you need to have the following functions:

* An init function, which receives the necessary config data.
* A start function, which continues to run while variables.state="running".
* A stop and restart function
* A getState function, which returns the current state of the gateway instance (running,stopping,stopped)
* A sendMessage function, which will be called when the CFML sendGatewayMessage function is used.

The following is all the code you need:

```lucee
	<cfcomponent output="no">
    <cfset variables.logFileName="DirectoryWatcher" />
    <cfset variables.state="stopped" />

    <cffunction name="init" access="public" output="no" returntype="void">
        <cfargument name="id" required="true" type="string" />
        <cfargument name="config" required="true" type="struct" default="#structNew()#" />
        <cfargument name="listener" required="true" type="component" />
        <cfset var cfcatch="" />
        <cftry>
            <cfset variables.id=id />
            <cfset variables.config=config />
            <cfset variables.listener=listener />
            <cflog text="init" type="information" file="#variables.logFileName#" />
            <cfcatch>
                <cfset _handleError(cfcatch, "init") /> 
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="start" access="public" output="no" returntype="void">
        <cfset var sleepStep=iif(variables.config.interval lt 500, 'variables.config.interval', de(500)) />
        <cfset var i=-1 />
        <cfset var cfcatch="" />
        <--- when restart() is called, we enter this loop untill the previous execution has ended. --->
            <cfwhile variables.state EQ "stopping">
                <cfset sleep(10)>
            </cfwhile>

            <cfset variables.state="running" />
            <cflog text="start" type="information" file="#variables.logFileName#">

            <cfwhile variables.state EQ "running">
                <cftry>
                    <--- YOUR GATEWAY ACTIONS HERE --->
                    <cfcatch>
                        <cfset _handleError(cfcatch, "start") /> 
                    </cfcatch>
                </cftry>
                <--- sleep untill the next run, but cut it into half seconds, so we can stop the gateway easily --->
                <cfloop from="#sleepStep#" to="#variables.config.interval#" step="#sleepStep#" index="i">
                    <cfset sleep(sleepStep) />
                    <cfif variables.state neq "running">
                        <cfbreak /> 
                    </cfif>
                </cfloop>
                <--- some extra sleeping if the requested timeout is not yet completely done --->
                <cfif variables.config.interval mod sleepStep and variables.state eq "running">
                    <cfset sleep((variables.config.interval mod sleepStep)) /> 
                </cfif>
            </cfwhile>
            <cfset variables.state="stopped" /> 
    </cffunction>

    <cffunction name="stop" access="public" output="no" returntype="void">
        <cflog text="stop" type="information" file="#variables.logFileName#">
            <cfset variables.state="stopping">
    </cffunction>

    <cffunction name="restart" access="public" output="no" returntype="void">
        <cfif variables.state EQ "running">
            <cfset stop()>
        </cfif>
        <cfset start()>
    </cffunction>

    <cffunction name="getState" access="public" output="no" returntype="string">
        <cfreturn variables.state /> 
    </cffunction>

    <cffunction name="sendMessage" access="public" output="no" returntype="string">
        <cfargument name="data" required="false" type="struct">
            <cfreturn "ERROR: sendMessage not supported">
    </cffunction>

    <cffunction name="_handleError" returntype="void" access="private" output="no">
        <cfargument name="catchData" required="yes" />
        <cfargument name="functionName" type="string" required="no" default="unknown" />
        <cflog text="Function #arguments.functionName#: #arguments.catchData.message# #arguments.catchData.detail#" type="error" file="#variables.logFileName#" /> 
    </cffunction>

</cfcomponent>
```

I guess you noticed the comment "YOUR GATEWAY ACTIONS HERE"? That's where you add the real functionality.

## The Gateway Driver ##

The driver is used to configure and define your Gateway. With it, you define the form fields in the Lucee admin settings page for your gateway, and it makes sure that your gateway is listed as an available Gateway.

The Gateway Driver is a CFC file, which must be added into the directory {Lucee-install}/lib/lucee-server/context/admin/gdriver/ 

## Gateway driver Functions ##

* **getClass():string.** Returns the java class name. If the gateway is Java based, then the java class has to implement the interface "org.opencfml.eventgateway.Gateway". If it is not java based, then this method must return an empty string or void.

* **getCFCPath():string.** Returns the cfc path, when the gateway is cfc based, If it is not cfc based, then this method must return an empty string or void.

* **getLabel():string.** The label (friendly name) of the gateway.

* **getDescription():string** The description of the gateway

* **onBeforeUpdate(string cfcPath, string startupMode, struct custom):void.** This method is invoked before the settings entered in the form are saved. This method can be used to validate the entered data.

* **onBeforeError(cfcatch):void.**  Invoked before an error is thrown. Can be used to throw your own error, and/or do logging.

* **getListenerCfcMode():string.** Can be one of the following:
	* "none": no listener gets defined
	* "required": defining a listener is required

* **getListenerPath():string** The default location of a listener cfc. (only used when the listenerCfcMode is not "none")

## Example Gateway driver ##

```lucee
<cfcomponent extends="Gateway" output="no">
    <--- The form fields which will be shown when adding a gateway instance via the Lucee admin --->
    <--- argument names (see file Gateway.cfc): displayName, name, defaultValue, required, description, type, values --->
    <cfset variables.fields = array( 
    	field( "Path to file", "filepath", "", true, "The file you want to check the size for", "text"), 
    	field( "Minimum file size", "minimalsize", "", true, "The minimum size of the file, in Bytes, before the Listener CFC is called", "text"), 
    	field( "Interval (ms)", "interval", "60000", true, "The interval between checks, in miliseconds", "text"), 
    	field( "CFC Listener Function name", "listenerFunction", "onChange", true, "Called when the file reaches the minimum file size", "text")
    ) />

    <cffunction name="getClass" returntype="string" output="no">
        <cfreturn "" /> 
    </cffunction>
            
    <cffunction name="getCFCPath" returntype="string" output="no">
        <cfreturn "filesizechecker.FileSizeWatcher" /> 
    </cffunction>
    
    <cffunction name="getLabel" returntype="string" output="no">
        <cfreturn "Filesize Watcher" /> 
    </cffunction>
    
    <cffunction name="getDescription" returntype="string" output="no">
        <cfreturn "Watches the filesize of a certain file" /> 
    </cffunction>
            
    <cffunction name="onBeforeUpdate" returntype="void" output="false">
        <cfargument name="cfcPath" required="true" type="string" />
        <cfargument name="startupMode" required="true" type="string" />
        <cfargument name="custom" required="true" type="struct" />
        <cfset var errors=[ ] />

        <--- does gven file exist? --->
        <cfif not fileExists(arguments.custom.filepath)>
            <cfset arrayAppend(errors, "The file [#arguments.custom.filepath#] does not exist") /> 
        </cfif>

        <--- interval --->
        <cfif not IsNumeric(custom.interval) or custom.interval LT 1 or int(custom.interval) neq custom.interval>
            <cfset arrayAppend(errors, "The interval [#custom.interval#] must be a numeric value greater than 0") /> 
        </cfif>

        <--- minimalsize --->
        <cfif not IsNumeric(custom.minimalsize) or custom.minimalsize LT 1 or int(custom.minimalsize) neq custom.minimalsize>
            <cfset arrayAppend(errors, "The Minimum file size [#custom.minimalsize#] must be a numeric value greater than 0") /> 
        </cfif>

        <cfif arrayLen(errors)>
            <cfthrow message="The following error(s) occured while validating your input: <ul><li>#arrayToList(errors, '</li><li>')#</li></ul>" /> 
        </cfif>
    </cffunction>

    <cffunction name="getListenerCfcMode" returntype="string" output="no" hint="Returns either 'none' or 'required'">
        <cfreturn "required" /> 
    </cffunction>

    <cffunction name="getListenerPath" returntype="string" output="no" hint="Returns the path to the default Listener cfc">
        <cfreturn "filesizechecker.FileBackuper" /> 
    </cffunction>
</cfcomponent>
```

Also see the file Gateway.cfc, which extends the functionality of this example (<cfcomponent extends="Gateway">)

## The Listener CFC ##

Most gateways need a Listener CFC to respond to events occuring in the Gateway instance. For example, if the Mail watcher finds new email in the mailbox, then it needs to do something with that event; it calls a method (function) of the Listener CFC. The path to your listener CFC must be given as an argument when you create or update a gateway instance. The contents of the CFC is completely up to you, as long as it has a public function that can be called by the Gateway.

### Example ###

Let's say our Gateway type to create is a "filesize checker", which checks a file for a minimum filesize. If the file's size has the minimum filesize, then we will call the listener CFC. First, we'll create the listener CFC:

<cfcomponent output="no">
	<cfset variables.logFileName = "BigFileBackup" />

```lucee
<cfcomponent output="no">
	<cffunction name="onBigFilesize" access="public" output="no" returntype="void">
	    <cfargument name="filepath" required="true" type="string" />
	    <cfargument name="size" required="true" type="numeric" />

	    <--- create a non-existing zipfile path--->
	    <cfset var zipFileName=a rguments.filepath & ".zip" />
	    <cfset var nr=1 />
	    <cfwhile fileExists(zipFileName)>
		    <cfset zipFileName=a rguments.filepath & ".#nr#.zip" />
		    <cfset ++nr /> 
		</cfwhile>
	        
	    <cftry>
	        <--- zip the file --->
	        <cfzip action="zip" source="#arguments.filepath#" file="#zipFileName#" />

	        <--- log the zip action --->
	        <cflog text="Backed up #arguments.filepath# to #zipFileName#" type="information" file="#variables.logFileName#" />
	                   
	        <--- now delete the file --->
	        <cffile action="delete" file="#arguments.filepath#" />

	        <cfcatch>
	            <cfset _handleError(cfcatch, "onBigFilesize") /> 
	        </cfcatch>
	    </cftry>
	</cffunction>

	<cffunction name="_handleError" returntype="void" access="private" output="no">
	    <cfargument name="catchData" required="yes" />
	    <cfargument name="functionName" type="string" required="no" default="unknown" />
	    <cflog text="Function #arguments.functionName#: #arguments.catchData.message# #arguments.catchData.detail#" type="error" file="#variables.logFileName#" /> 
	</cffunction>
</cfcomponent>
```
We will save the file as {Lucee-install}/lib/lucee-server/context/gateway/filesizechecker/FileBackuper.cfc

Now we will add the "file size check" functionality into our gateway cfc. We'll replace "YOUR GATEWAY ACTIONS HERE" with the following:

```lucee
<cfset var qFile = "" />
<---  get the file's size by using cfdirectory --->
<cfdirectory action="list" directory="#getDirectoryFromPath(variables.config.filepath)#"
	filter="#getFileFromPath(variables.config.filepath)#" name="qFile" />

<---  call the listener CFC if the file size meets the minimum requirement --->
<cfif qFile.recordcount and qFile.size gte variables.config.minimalsize>
<cfset variables.listener[variables.config.listenerFunction](
qFile.directory & server.separator.file & qFile.name
, qFile.size
) />
</cfif>
```
We will save the file as {Lucee-install}/lib/lucee-server/context/gateway/filesizechecker/FileSizeWatcher.cfc

Btw: the variables.listener and variables.config variables did not just come falling from the sky; instead, it was saved to the variables scope in the init() function.

Lastly, we need to create the Gateway driver. We can use the Gateway driver code which was shown before, and then save it as {Lucee-install}/lib/lucee-server/context/admin/gdriver/FileSizeWatcher.cfc

Now we are almost good to go! We do need to restart Lucee to have it pick up the new Gateway driver. So just go to the server admin, click on the menu-item "Restart", and then hit the "Restart Lucee" button.

We can add an instance of our new Gateway type now! You can do it by using cfadmin like this:

```lucee
<cfadmin action="updateGatewayEntry" type="server" password="server-admin-password"
	startupMode="automatic"
	id="zipLargeLogFiles"
	class=""
	cfcpath="filesizechecker.FileSizeWatcher"
	listenerCfcPath="filesizechecker.FileBackuper"
	custom='#{
		  filepath = "C:/mysite/logs/failedlogins.log"
		, listenerFunction = "onBigFilesize"
		, minimalsize = 100000
		, interval = 60000
	}#'
	readOnly=false
/>
```

Interval: time in milliseconds to wait between each check Minimalsize: the minimum filesize in bytes


After executing the cfadmin code, or going through the admin screens, you should now have an instance of your own Event Gateway type running!

When creating a Socket gateway or an Instant messaging gateway, you will need to do a bit more coding, but hopefully this instruction helped you out!



