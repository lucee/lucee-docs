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
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> variables.logFileName = <span style="color:#2A00FF; ">&#34;DirectoryWatcher&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> variables.state=<span style="color:#2A00FF; ">&#34;stopped&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>

	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffunction</span></strong> name=<span style="color:#2A00FF; ">&#34;init&#34;</span> access=<span style="color:#2A00FF; ">&#34;public&#34;</span> output=<span style="color:#2A00FF; ">&#34;no&#34;</span> returntype=<span style="color:#2A00FF; ">&#34;void&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfargument</span></strong> name=<span style="color:#2A00FF; ">&#34;id&#34;</span> required=<span style="color:#2A00FF; ">&#34;true&#34;</span> type=<span style="color:#2A00FF; ">&#34;string&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfargument</span></strong> name=<span style="color:#2A00FF; ">&#34;config&#34;</span> required=<span style="color:#2A00FF; ">&#34;true&#34;</span> type=<span style="color:#2A00FF; ">&#34;struct&#34;</span> <span style="color:#7F0055; font-weight: bold; ">default</span>=<span style="color:#2A00FF; ">&#34;#structNew()#&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfargument</span></strong> name=<span style="color:#2A00FF; ">&#34;listener&#34;</span> required=<span style="color:#2A00FF; ">&#34;true&#34;</span> type=<span style="color:#2A00FF; ">&#34;component&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> <span style="color:#7F0055; font-weight: bold; ">var</span> cfcatch = <span style="color:#2A00FF; ">&#34;&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cftry&#62;</span></strong>
			<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> variables.id=id <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
			<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> variables.config=config <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
			<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> variables.listener=listener <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
			
			<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cflog</span></strong> text=<span style="color:#2A00FF; ">&#34;init&#34;</span> type=<span style="color:#2A00FF; ">&#34;information&#34;</span> file=<span style="color:#2A00FF; ">&#34;#variables.logFileName#&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
			<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfcatch&#62;</span></strong>
				<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> _handleError(cfcatch, <span style="color:#2A00FF; ">&#34;init&#34;</span>) <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
			<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cfcatch&#62;</span></strong>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cftry&#62;</span></strong>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cffunction&#62;</span></strong>

	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffunction</span></strong> name=<span style="color:#2A00FF; ">&#34;start&#34;</span> access=<span style="color:#2A00FF; ">&#34;public&#34;</span> output=<span style="color:#2A00FF; ">&#34;no&#34;</span> returntype=<span style="color:#2A00FF; ">&#34;void&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> <span style="color:#7F0055; font-weight: bold; ">var</span> sleepStep = iif(variables.config.interval <span style="color:#7F0055; font-weight: bold; ">lt</span> 500, <span style="color:#2A00FF; ">&#39;variables.config.interval&#39;</span>, de(500)) <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> <span style="color:#7F0055; font-weight: bold; ">var</span> i=-1 <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> <span style="color:#7F0055; font-weight: bold; ">var</span> cfcatch = <span style="color:#2A00FF; ">&#34;&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
		<span style="color:#3F7F5F; ">&#60;---  when restart() is called, we enter this loop untill the previous execution has ended. ---&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfwhile</span></strong> variables.state EQ <span style="color:#2A00FF; ">&#34;stopping&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
			<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> sleep(10)<span style="color:#7F0055; font-weight: bold; ">&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cfwhile&#62;</span></strong>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> variables.state = <span style="color:#2A00FF; ">&#34;running&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
		
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cflog</span></strong> text=<span style="color:#2A00FF; ">&#34;start&#34;</span> type=<span style="color:#2A00FF; ">&#34;information&#34;</span> file=<span style="color:#2A00FF; ">&#34;#variables.logFileName#&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
		
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfwhile</span></strong> variables.state EQ <span style="color:#2A00FF; ">&#34;running&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
			<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cftry&#62;</span></strong>
				<span style="color:#3F7F5F; ">&#60;---

					YOUR GATEWAY ACTIONS HERE
				---&#62;</span>
				<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfcatch&#62;</span></strong>
					<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> _handleError(cfcatch, <span style="color:#2A00FF; ">&#34;start&#34;</span>) <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
				<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cfcatch&#62;</span></strong>
			<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cftry&#62;</span></strong>
			<span style="color:#3F7F5F; ">&#60;---  sleep untill the next run, but cut it into half seconds, so we can stop the gateway easily ---&#62;</span>
			<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfloop</span></strong> from=<span style="color:#2A00FF; ">&#34;#sleepStep#&#34;</span> to=<span style="color:#2A00FF; ">&#34;#variables.config.interval#&#34;</span> step=<span style="color:#2A00FF; ">&#34;#sleepStep#&#34;</span> index=<span style="color:#2A00FF; ">&#34;i&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
				<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> sleep(sleepStep) <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
				<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfif</span></strong> variables.state <span style="color:#7F0055; font-weight: bold; ">neq</span> <span style="color:#2A00FF; ">&#34;running&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
					<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfbreak</span></strong> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
				<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cfif&#62;</span></strong>
			<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cfloop&#62;</span></strong>
			<span style="color:#3F7F5F; ">&#60;---  some extra sleeping if the requested timeout is not yet completely done ---&#62;</span>
			<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfif</span></strong> variables.config.interval mod sleepStep and variables.state <span style="color:#7F0055; font-weight: bold; ">eq</span> <span style="color:#2A00FF; ">&#34;running&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
				<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> sleep((variables.config.interval mod sleepStep)) <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
			<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cfif&#62;</span></strong>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cfwhile&#62;</span></strong>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> variables.state=<span style="color:#2A00FF; ">&#34;stopped&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cffunction&#62;</span></strong>

	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffunction</span></strong> name=<span style="color:#2A00FF; ">&#34;stop&#34;</span> access=<span style="color:#2A00FF; ">&#34;public&#34;</span> output=<span style="color:#2A00FF; ">&#34;no&#34;</span> returntype=<span style="color:#2A00FF; ">&#34;void&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cflog</span></strong> text=<span style="color:#2A00FF; ">&#34;stop&#34;</span> type=<span style="color:#2A00FF; ">&#34;information&#34;</span> file=<span style="color:#2A00FF; ">&#34;#variables.logFileName#&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> variables.state=<span style="color:#2A00FF; ">&#34;stopping&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cffunction&#62;</span></strong>

	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffunction</span></strong> name=<span style="color:#2A00FF; ">&#34;restart&#34;</span> access=<span style="color:#2A00FF; ">&#34;public&#34;</span> output=<span style="color:#2A00FF; ">&#34;no&#34;</span> returntype=<span style="color:#2A00FF; ">&#34;void&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfif</span></strong> variables.state EQ <span style="color:#2A00FF; ">&#34;running&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span><strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> stop()<span style="color:#7F0055; font-weight: bold; ">&#62;</span><strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cfif&#62;</span></strong>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> start()<span style="color:#7F0055; font-weight: bold; ">&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cffunction&#62;</span></strong>

	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffunction</span></strong> name=<span style="color:#2A00FF; ">&#34;getState&#34;</span> access=<span style="color:#2A00FF; ">&#34;public&#34;</span> output=<span style="color:#2A00FF; ">&#34;no&#34;</span> returntype=<span style="color:#2A00FF; ">&#34;string&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfreturn</span></strong> variables.state <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cffunction&#62;</span></strong>

	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffunction</span></strong> name=<span style="color:#2A00FF; ">&#34;sendMessage&#34;</span> access=<span style="color:#2A00FF; ">&#34;public&#34;</span> output=<span style="color:#2A00FF; ">&#34;no&#34;</span> returntype=<span style="color:#2A00FF; ">&#34;string&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfargument</span></strong> name=<span style="color:#2A00FF; ">&#34;data&#34;</span> required=<span style="color:#2A00FF; ">&#34;false&#34;</span> type=<span style="color:#2A00FF; ">&#34;struct&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfreturn</span></strong> <span style="color:#2A00FF; ">&#34;ERROR: sendMessage not supported&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cffunction&#62;</span></strong>
		
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffunction</span></strong> name=<span style="color:#2A00FF; ">&#34;_handleError&#34;</span> returntype=<span style="color:#2A00FF; ">&#34;void&#34;</span> access=<span style="color:#2A00FF; ">&#34;private&#34;</span> output=<span style="color:#2A00FF; ">&#34;no&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfargument</span></strong> name=<span style="color:#2A00FF; ">&#34;catchData&#34;</span> required=<span style="color:#2A00FF; ">&#34;yes&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfargument</span></strong> name=<span style="color:#2A00FF; ">&#34;functionName&#34;</span> type=<span style="color:#2A00FF; ">&#34;string&#34;</span> required=<span style="color:#2A00FF; ">&#34;no&#34;</span> <span style="color:#7F0055; font-weight: bold; ">default</span>=<span style="color:#2A00FF; ">&#34;unknown&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cflog</span></strong> text=<span style="color:#2A00FF; ">&#34;Function #arguments.functionName#: #arguments.catchData.message# #arguments.catchData.detail#&#34;</span>
		type=<span style="color:#2A00FF; ">&#34;error&#34;</span> file=<span style="color:#2A00FF; ">&#34;#variables.logFileName#&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cffunction&#62;</span></strong>
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

<span style="color:#3F7F5F; ">&#60;---  The form fields which will be shown when adding a gateway instance via the Lucee admin ---&#62;</span>
<span style="color:#3F7F5F; ">&#60;---  argument names (see file Gateway.cfc):
	displayName, name, defaultValue, required, description, type, values ---&#62;</span>
<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> variables.fields = array(
	field(<span style="color:#2A00FF; ">&#34;Path to file&#34;</span>, <span style="color:#2A00FF; ">&#34;filepath&#34;</span>, <span style="color:#2A00FF; ">&#34;&#34;</span>, <span style="color:#7F0055; font-weight: bold; ">true</span>, <span style="color:#2A00FF; ">&#34;The file you want to check the size for&#34;</span>, <span style="color:#2A00FF; ">&#34;text&#34;</span>)
	, field(<span style="color:#2A00FF; ">&#34;Minimum file size&#34;</span>, <span style="color:#2A00FF; ">&#34;minimalsize&#34;</span>, <span style="color:#2A00FF; ">&#34;&#34;</span>, <span style="color:#7F0055; font-weight: bold; ">true</span>, <span style="color:#2A00FF; ">&#34;The minimum size of the file, in Bytes, before the Listener CFC is called&#34;</span>, <span style="color:#2A00FF; ">&#34;text&#34;</span>)
	, field(<span style="color:#2A00FF; ">&#34;Interval (ms)&#34;</span>, <span style="color:#2A00FF; ">&#34;interval&#34;</span>, <span style="color:#2A00FF; ">&#34;60000&#34;</span>, <span style="color:#7F0055; font-weight: bold; ">true</span>, <span style="color:#2A00FF; ">&#34;The interval between checks, in miliseconds&#34;</span>, <span style="color:#2A00FF; ">&#34;text&#34;</span>)
	, field(<span style="color:#2A00FF; ">&#34;CFC Listener Function name&#34;</span>, <span style="color:#2A00FF; ">&#34;listenerFunction&#34;</span>, <span style="color:#2A00FF; ">&#34;onChange&#34;</span>, <span style="color:#7F0055; font-weight: bold; ">true</span>, <span style="color:#2A00FF; ">&#34;Called when the file reaches the minimum file size&#34;</span>, <span style="color:#2A00FF; ">&#34;text&#34;</span>)
) <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>

<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffunction</span></strong> name=<span style="color:#2A00FF; ">&#34;getClass&#34;</span> returntype=<span style="color:#2A00FF; ">&#34;string&#34;</span> output=<span style="color:#2A00FF; ">&#34;no&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfreturn</span></strong> <span style="color:#2A00FF; ">&#34;&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cffunction&#62;</span></strong>

<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffunction</span></strong> name=<span style="color:#2A00FF; ">&#34;getCFCPath&#34;</span> returntype=<span style="color:#2A00FF; ">&#34;string&#34;</span> output=<span style="color:#2A00FF; ">&#34;no&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfreturn</span></strong> <span style="color:#2A00FF; ">&#34;filesizechecker.FileSizeWatcher&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cffunction&#62;</span></strong>

<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffunction</span></strong> name=<span style="color:#2A00FF; ">&#34;getLabel&#34;</span> returntype=<span style="color:#2A00FF; ">&#34;string&#34;</span> output=<span style="color:#2A00FF; ">&#34;no&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfreturn</span></strong> <span style="color:#2A00FF; ">&#34;Filesize Watcher&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cffunction&#62;</span></strong>

<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffunction</span></strong> name=<span style="color:#2A00FF; ">&#34;getDescription&#34;</span> returntype=<span style="color:#2A00FF; ">&#34;string&#34;</span> output=<span style="color:#2A00FF; ">&#34;no&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfreturn</span></strong> <span style="color:#2A00FF; ">&#34;Watches the filesize of a certain file&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cffunction&#62;</span></strong>

<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffunction</span></strong> name=<span style="color:#2A00FF; ">&#34;onBeforeUpdate&#34;</span> returntype=<span style="color:#2A00FF; ">&#34;void&#34;</span> output=<span style="color:#2A00FF; ">&#34;false&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfargument</span></strong> name=<span style="color:#2A00FF; ">&#34;cfcPath&#34;</span> required=<span style="color:#2A00FF; ">&#34;true&#34;</span> type=<span style="color:#2A00FF; ">&#34;string&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfargument</span></strong> name=<span style="color:#2A00FF; ">&#34;startupMode&#34;</span> required=<span style="color:#2A00FF; ">&#34;true&#34;</span> type=<span style="color:#2A00FF; ">&#34;string&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfargument</span></strong> name=<span style="color:#2A00FF; ">&#34;custom&#34;</span> required=<span style="color:#2A00FF; ">&#34;true&#34;</span> type=<span style="color:#2A00FF; ">&#34;struct&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> <span style="color:#7F0055; font-weight: bold; ">var</span> errors = [] <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	
	<span style="color:#3F7F5F; ">&#60;---  does gven file exist? ---&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfif</span></strong> <span style="color:#7F0055; font-weight: bold; ">not</span> fileExists(arguments.custom.filepath)<span style="color:#7F0055; font-weight: bold; ">&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> arrayAppend(errors, <span style="color:#2A00FF; ">&#34;The file [#arguments.custom.filepath#] does not exist&#34;</span>) <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cfif&#62;</span></strong>
	<span style="color:#3F7F5F; ">&#60;---  interval ---&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfif</span></strong> <span style="color:#7F0055; font-weight: bold; ">not</span> IsNumeric(custom.interval) or custom.interval LT 1 or int(custom.interval) <span style="color:#7F0055; font-weight: bold; ">neq</span> custom.interval<span style="color:#7F0055; font-weight: bold; ">&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> arrayAppend(errors, <span style="color:#2A00FF; ">&#34;The interval [#custom.interval#] must be a numeric value greater than 0&#34;</span>) <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cfif&#62;</span></strong>
	<span style="color:#3F7F5F; ">&#60;---  minimalsize ---&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfif</span></strong> <span style="color:#7F0055; font-weight: bold; ">not</span> IsNumeric(custom.minimalsize) or custom.minimalsize LT 1 or int(custom.minimalsize) <span style="color:#7F0055; font-weight: bold; ">neq</span> custom.minimalsize<span style="color:#7F0055; font-weight: bold; ">&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> arrayAppend(errors, <span style="color:#2A00FF; ">&#34;The Minimum file size [#custom.minimalsize#] must be a numeric value greater than 0&#34;</span>) <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cfif&#62;</span></strong>

	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfif</span></strong> arrayLen(errors)<span style="color:#7F0055; font-weight: bold; ">&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfthrow</span></strong> message=<span style="color:#2A00FF; ">&#34;The following error(s) occured while validating your input: &#60;ul&#62;&#60;li&#62;#arrayToList(errors, &#39;&#60;/li&#62;&#60;li&#62;&#39;)#&#60;/li&#62;&#60;/ul&#62;&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cfif&#62;</span></strong>
<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cffunction&#62;</span></strong>

<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffunction</span></strong> name=<span style="color:#2A00FF; ">&#34;getListenerCfcMode&#34;</span> returntype=<span style="color:#2A00FF; ">&#34;string&#34;</span> output=<span style="color:#2A00FF; ">&#34;no&#34;</span>
hint=<span style="color:#2A00FF; ">&#34;Returns either &#39;none&#39; or &#39;required&#39;&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfreturn</span></strong> <span style="color:#2A00FF; ">&#34;required&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cffunction&#62;</span></strong>

<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffunction</span></strong> name=<span style="color:#2A00FF; ">&#34;getListenerPath&#34;</span> returntype=<span style="color:#2A00FF; ">&#34;string&#34;</span> output=<span style="color:#2A00FF; ">&#34;no&#34;</span>
hint=<span style="color:#2A00FF; ">&#34;Returns the path to the default Listener cfc&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfreturn</span></strong> <span style="color:#2A00FF; ">&#34;filesizechecker.FileBackuper&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cffunction&#62;</span></strong>
<cfcomponnet>
```

Also see the file Gateway.cfc, which extends the functionality of this example (<cfcomponent extends="Gateway">)

## The Listener CFC ##

Most gateways need a Listener CFC to respond to events occuring in the Gateway instance. For example, if the Mail watcher finds new email in the mailbox, then it needs to do something with that event; it calls a method (function) of the Listener CFC. The path to your listener CFC must be given as an argument when you create or update a gateway instance. The contents of the CFC is completely up to you, as long as it has a public function that can be called by the Gateway.

### Example ###

Let's say our Gateway type to create is a "filesize checker", which checks a file for a minimum filesize. If the file's size has the minimum filesize, then we will call the listener CFC. First, we'll create the listener CFC:

<cfcomponent output="no">
	<cfset variables.logFileName = "BigFileBackup" />

```lucee
<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffunction</span></strong> name=<span style="color:#2A00FF; ">&#34;onBigFilesize&#34;</span> access=<span style="color:#2A00FF; ">&#34;public&#34;</span> output=<span style="color:#2A00FF; ">&#34;no&#34;</span> returntype=<span style="color:#2A00FF; ">&#34;void&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfargument</span></strong> name=<span style="color:#2A00FF; ">&#34;filepath&#34;</span> required=<span style="color:#2A00FF; ">&#34;true&#34;</span> type=<span style="color:#2A00FF; ">&#34;string&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfargument</span></strong> name=<span style="color:#2A00FF; ">&#34;size&#34;</span> required=<span style="color:#2A00FF; ">&#34;true&#34;</span> type=<span style="color:#2A00FF; ">&#34;numeric&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<span style="color:#3F7F5F; ">&#60;---  create a non-existing zipfile path---&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> <span style="color:#7F0055; font-weight: bold; ">var</span> zipFileName = arguments.filepath &#38; <span style="color:#2A00FF; ">&#34;.zip&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> <span style="color:#7F0055; font-weight: bold; ">var</span> nr=1 <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfwhile</span></strong> fileExists(zipFileName)<span style="color:#7F0055; font-weight: bold; ">&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> zipFileName = arguments.filepath &#38; <span style="color:#2A00FF; ">&#34;.#nr#.zip&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> ++nr <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cfwhile&#62;</span></strong>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cftry&#62;</span></strong>
		<span style="color:#3F7F5F; ">&#60;---  zip the file ---&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfzip</span></strong> action=<span style="color:#2A00FF; ">&#34;zip&#34;</span> source=<span style="color:#2A00FF; ">&#34;#arguments.filepath#&#34;</span> file=<span style="color:#2A00FF; ">&#34;#zipFileName#&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
		<span style="color:#3F7F5F; ">&#60;---  log the zip action ---&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cflog</span></strong> text=<span style="color:#2A00FF; ">&#34;Backed up #arguments.filepath# to #zipFileName#&#34;</span>
			type=<span style="color:#2A00FF; ">&#34;information&#34;</span> file=<span style="color:#2A00FF; ">&#34;#variables.logFileName#&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
		<span style="color:#3F7F5F; ">&#60;---  now delete the file ---&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffile</span></strong> action=<span style="color:#2A00FF; ">&#34;delete&#34;</span> file=<span style="color:#2A00FF; ">&#34;#arguments.filepath#&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfcatch&#62;</span></strong>
			<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfset</span></strong> _handleError(cfcatch, <span style="color:#2A00FF; ">&#34;onBigFilesize&#34;</span>) <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
		<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cfcatch&#62;</span></strong>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cftry&#62;</span></strong>
<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cffunction&#62;</span></strong>
		
<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cffunction</span></strong> name=<span style="color:#2A00FF; ">&#34;_handleError&#34;</span> returntype=<span style="color:#2A00FF; ">&#34;void&#34;</span> access=<span style="color:#2A00FF; ">&#34;private&#34;</span> output=<span style="color:#2A00FF; ">&#34;no&#34;</span><span style="color:#7F0055; font-weight: bold; ">&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfargument</span></strong> name=<span style="color:#2A00FF; ">&#34;catchData&#34;</span> required=<span style="color:#2A00FF; ">&#34;yes&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cfargument</span></strong> name=<span style="color:#2A00FF; ">&#34;functionName&#34;</span> type=<span style="color:#2A00FF; ">&#34;string&#34;</span> required=<span style="color:#2A00FF; ">&#34;no&#34;</span> <span style="color:#7F0055; font-weight: bold; ">default</span>=<span style="color:#2A00FF; ">&#34;unknown&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
	<strong><span style="color:#7F0055; font-weight: bold; ">&#60;cflog</span></strong> text=<span style="color:#2A00FF; ">&#34;Function #arguments.functionName#: #arguments.catchData.message# #arguments.catchData.detail#&#34;</span>
	type=<span style="color:#2A00FF; ">&#34;error&#34;</span> file=<span style="color:#2A00FF; ">&#34;#variables.logFileName#&#34;</span> <span style="color:#7F0055; font-weight: bold; ">/&#62;</span>
<strong><span style="color:#7F0055; font-weight: bold; ">&#60;/cffunction&#62;</span></strong>
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



