---
title: Creating an extension for Lucee (1/5)
id: tutorial-extension-provider-part1
categories:
- extensions
menuTitle: Creating an extension for Lucee (1/5)
description: Creating a local extension provider
---

## Creating an extension for Lucee 3.1 - Part I ##

### Step 1 - Creating a local extension provider ###

In the Lucee admin you are able to add extension providers to the existing list of providers. So we are going to create a local provider that runs on the local system and gets queried in the application listing. In order to do so just create a component named ExtensionProvider.cfc that contains the following remote methods:

**getInfo()**

This method returns information about the extension provider. This is important when the applications are listed in the admin. This method creates a struct called 'info' (which is returned) that contains the following keys:

* title - Title of the provider
* description - Descriptive text of the provider
* image - An image if you like to provide one
* url - URL of the provider
* mode - production (caching is turned on) or develop (caching turned off - for development)

Here's an example:

```lucee
<cffunction name="getInfo" access="remote" returntype="struct" output="no">
	<cfset var info = {}>
	<cfset info.title="Lucee ("&cgi.HTTP_HOST&")">
	<cfset info.description="">
	<cfset info.image="http://www.lucee.ch/img.jpg">
	<cfset info.url="http://"&cgi.HTTP_HOST>
	<cfset info.mode="develop">
	<cfreturn info>
</cffunction>
```

**listApplications()** This method returns a query that contains information about the applications that the provider contains. The following data & metadata can be defined:

* id - Application id
* name - Name of the application
* type ** 'web' - visible in the webadmin ** 'server' - visible in the server admin ** 'all' - visible in both admins
* label - Label appearing in the application list
* description - Detailed description of the application.
* author - Author of the application
* codename - Release codename
* video - video that could be displayed in the web admin
* image - image that could be displayed in the web admin
* support - link to a support website
* documentation - link to a documentation website
* forum - link to an application forum
* mailinglist - email address of the official mailing list
* network - no idea
* created - date of the release
* version - version number
* category - category of the application
* download - download url of the application

The most important element is the download link. This link defines where the installation repository is located. If you return an empty string here, the method getDownloadDetails() is called. Here's an example of a **listApplications()** method.

```lucee
<cffunction name="listApplications" access="remote" returntype="query" output="no">
	<cfset var apps = queryNew('type,id,name,label,description,version,category,image,download,author,' &
'codename,video,support,documentation,forum,mailinglist,network,created')>
	<cfset var rootURL=getInfo().url>
	<!--- Mango Blog --->
	<cfsavecontent variable="desc">Mango Blog is an extensible blog engine released under the Apache license, built with ColdFusion. It provides the core engine to administer and publish entries and the necessary architecture to extend its basic functionality by adding plugins. Mango Blog can be easily customized by the use of exchangeable and completely customizable skins.</cfsavecontent>
	<cfset QueryAddRow(apps)>
	<cfset QuerySetCell(apps,'id','13')>
	<cfset QuerySetCell(apps,'name','Mango Blog')>
	<cfset QuerySetCell(apps,'type','web')>
	<cfset QuerySetCell(apps,'label','Mango Blog - A sweet CFML blog engine')>
	<cfset QuerySetCell(apps,'description',desc)>
	<cfset QuerySetCell(apps,'author','Laura Arguello')>
	<cfset QuerySetCell(apps,'codename','')>
	<cfset QuerySetCell(apps,'video','')>
	<cfset QuerySetCell(apps,'image','http://www.mangoblog.org/assets/content/images/badges/mangoblog_logo_lucee.png')>
	<cfset QuerySetCell(apps,'support','http://www.mangoblog.org/forums/forums.cfm?conferenceid=9AE6B18E-3048-2A53-70ED34C1EDD7251D')>
	<cfset QuerySetCell(apps,'documentation','http://www.mangoblog.org/docs/documentation')>
	<cfset QuerySetCell(apps,'forum','')>
	<cfset QuerySetCell(apps,'mailinglist','')>
	<cfset QuerySetCell(apps,'network','')>
	<cfset QuerySetCell(apps,'created',CreateDate(2009,2,24))>
	<cfset QuerySetCell(apps,'version',"1_3_1")>
	<cfset QuerySetCell(apps,'category',"Application")>
	<cfset QuerySetCell(apps,'download',rootURL&'/mangoinstaller.zip')>
	<cfreturn apps>
</cffunction>
```

The above method returns a query that is hardcoded. Since it is the one I am using for the creation of this extension I'll leave it that way. Typically, this is where you would query a database here that returns all applications and their data your extension provider offers

**getDownloadDetails()**

This method is actually important since with its help you can implement a payment method if you plan to offer paid extensions. The function takes the following arguments:

* type - type of the administrator calling this method remotely (webserver)
* serverid - ID of the server that is calling the method (uuid)
* webid - ID of the web calling the method (uuid)
* appid - ID of the application that is supposed to be installed. Defined in the listApplications() query
* serialNumber - Serial number of the web/server admin (optional value; string)

We normally recommend the following process:

* Create a shop where people buy applications and acquire credits to purchase applications.
* If the application is about to be installed the getDownloadDetails method is called by the Lucee administrator. Now you can return a check option that allows you to collect the user's credentials and query for their installation credits for this application. But again it's mostly up to you what this method does or does not.
* If the query for credit responds with a positive number the download link can be returned otherwise not.

Here's an example for a getDownloadDetails() method:

```lucee
<cffunction name="getDownloadDetails" access="remote" returntype="struct" output="no">
	<cfargument name="type" required="yes" type="string">
	<cfargument name="serverId" required="yes" type="string">
	<cfargument name="webId" required="yes" type="string">
	<cfargument name="appId" required="yes" type="string">
	<cfargument name="serialNumber" required="no" type="string" default="" />
	<cfset var data= {}>
	<cfset data.error=appId EQ 15>
	<cfif data.error>
		<cfif structKeyExists(form, "username")>
			<cfquery>
			<!--- cfquery your database for the user and his credits for this app --->
			</cfquery>
			<cfset data.url=getInfo().url&'/'&getNameById(arguments.appId)&'/mangoinstaller.zip'>
		<cfelse>
			<cfset data.message = "Please enter your login credentials: <form action>...</form>">
		</cfif>
	</cfif>
	<cfset data.url="">
	<cfreturn data>
</cffunction>
```

### Adding the extension provider to a local context ###

Now you need to add the newly created ExtensionProvider.cfc to one of your local web contexts. Just go to the Lucee web admin and click on Extensions/providers and add for instance the following extension provider: ([http://localcontext/ext/ExtensionProvider.cfc](http://localcontext/ext/ExtensionProvider.cfc)) Assuming that the cfc is located in a subfolder called 'ext' below the webroot.

When you now call the extensions/applications page your extension should be listed.

If you did everything correctly, your example should look like [Part_I_Example.zip](http://assets.luceewiki.s3.amazonaws.com/tutorials/Part_I_Example.zip). If you go any further with the installation, you'll get an error in Lucee. That's because we now have to setup our zip file to accommodate being install through Lucee's Applications panel which will be discussed in Part II.

[[tutorial-extension-provider-part2]]
