<!--
{
  "title": "Custom Event Gateways",
  "id": "custom-event-gateways",
  "categories": [
    "gateways"
  ],
  "description": "Here you will find a short introduction into writing your own Event Gateway type.",
  "keywords": [
    "Event Gateway",
    "Custom Gateway",
    "Directory Watcher",
    "File Size Checker",
    "Lucee",
    "Gateway Driver"
  ]
}
-->

# Custom Event Gateways

Write custom Event Gateways in pure CFML (or Java). You need 2-3 files:

- the Gateway CFC
- the Gateway Driver CFC
- A listener CFC

## The Gateway CFC

This is the file which contains the action you want your gateway to do.

Also, it is the file which is instantiated by Lucee when the gateway starts.

You can take the following files as an example:

- `{lucee-server}/context/gateway/DirectoryWatcher.cfc` ([source](https://github.com/lucee/Lucee/blob/7.0/core/src/main/cfml/context/gateway/DirectoryWatcher.cfc))
- `{lucee-server}/context/gateway/MailWatcher.cfc` ([source](https://github.com/lucee/Lucee/blob/7.0/core/src/main/cfml/context/gateway/MailWatcher.cfc))

The example code shown underneath is based on `DirectoryWatcher.cfc`.

By default, you need to have the following functions:

- An `init` function, which receives the necessary config data.
- A `start` function, which continues to run while `variables.state="running"`.
- A `stop` and `restart` function.
- A `getState` function, which returns the current state of the gateway instance (`running`, `stopping`, `stopped`).
- A `sendMessage` function, which will be called when the CFML `sendGatewayMessage` function is used.

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
    </cffunction>

    <cffunction name="start" access="public" output="no" returntype="void">
        <cfset variables.state = "running" />
        <cfloop condition="variables.state EQ 'running'">
            <cftry>
                <cfset checkFileSize() />
                <cfcatch type="any">
                    <cfset variables.listener.onError(cfcatch) />
                </cfcatch>
            </cftry>
        </cfloop>
    </cffunction>

    <cffunction name="stop" access="public" output="no" returntype="void">
        <cfset variables.state = "stopped" />
    </cffunction>

    <cffunction name="restart" access="public" output="no" returntype="void">
        <cfset stop() />
        <cfset start() />
    </cffunction>

    <cffunction name="getState" access="public" output="no" returntype="string">
        <cfreturn variables.state />
    </cffunction>

    <cffunction name="sendMessage" access="public" output="no" returntype="void">
        <cfargument name="data" required="true" type="any" />
        <!--- handle incoming messages here --->
    </cffunction>

    <cffunction name="checkFileSize" access="private" output="no" returntype="void">
        <cfquery name="qFile" datasource="#variables.config.datasource#">
            SELECT *
            FROM FILE
            WHERE directory = <cfqueryparam value="#getDirectoryFromPath(variables.config.filepath)#" cfsqltype="cf_sql_varchar">
            AND name = <cfqueryparam value="#getFileFromPath(variables.config.filepath)#" cfsqltype="cf_sql_varchar">
        </cfquery>

        <!--- call the listener CFC if the file size meets the minimum requirement --->
        <cfif qFile.recordcount and qFile.size gte variables.config.minimalsize>
            <cfset variables.listener[variables.config.listenerFunction](qFile.directory & server.separator.file & qFile.name, qFile.size) />
        </cfif>
    </cffunction>
</cfcomponent>
```

We will save the file as `{lucee-server}/context/gateway/filesizechecker/FileSizeWatcher.cfc`.

The `variables.listener` and `variables.config` variables did not just come falling from the sky; instead, they were saved to the variables scope in the `init()` function.

Lastly, we need to create the Gateway driver. We can use the Gateway driver code shown before, and then save it as `{lucee-server}/context/admin/gdriver/FileSizeWatcher.cfc`.

Now we are almost good to go! We do need to restart Lucee to have it pick up the new Gateway driver. So just go to the server admin, click on the menu-item "Restart", and then hit the "Restart Lucee" button.

We can add an instance of our new Gateway type now! You can do it by using cfadmin like this:

```lucee
<cfadmin action="updateGatewayEntry" type="server" password="server-admin-password"
    startupMode="automatic"
    id="zipLargeLogFiles"
    class=""
    cfcpath="filesizechecker.FileSizeWatcher"
    listenerCfcPath="filesizechecker.FileBackuper"
    custom="# {
        filepath = "C:/mysite/logs/failedlogins.log",
        listenerFunction = "onBigFilesize",
        minimalsize = 100000,
        interval = 60000
    } #"
    readOnly="false"
/>
```

Interval: time in milliseconds to wait between each check.
Minimalsize: the minimum filesize in bytes.

After executing the cfadmin code, or going through the admin screens, you should now have an instance of your own Event Gateway type running!

When creating a Socket gateway or an Instant messaging gateway, you will need to do a bit more coding, but hopefully this instruction helped you out!
