---
title: Extension Provider
id: extensions-extension-provider
---

## Extension provider (webservice) ##

Extensions are provided by the Extension Provider. An Extension Provider is a webservice that obeys a certain interface described below. Extension Provider can easily be registered in the Lucee Administrator. All you have to do is to enter and save the URL address pointing to it.

Let’s have a look at the interface of the extension providers. As already said it is a webservice that can be programmed in any given technology. In our examples we are using a CFC (CF Component).

### Interface ###

The interface of the Extension Provider contains two public methods:

* getInfo(): struct - Returns information about the provider
* listApplications():query - Lists all the applications provided by the provider

**getInfo**

This method returns information about the extension provider itself. It returns a struct that contains the following Data (still under construction):

Key | Description
------------ | -------------
title | Title of the extension provider
description | Description of the extension provider
image | Link to an image
url | URL for more information
mode | Defines how the Information of the ExtensionProvider is cached in the client (Lucee Administrator). Valid values are:
<ul><li>develop - does not cache the result of the extension provider</li>
<li>production (or no value) - caches the result in the session scope of the consumer</li></ul>

### listApplications ###

This method returns a query with all available Extensions. One row represents one extension. Below the contents of the columns of the query are described.

Key | Description
------------ | -------------
id | Identifier of the extension
name | Name of the extension, must be a valid CFML variable name
label | Display name of the extension
description | Extension description
author | Author of the extension
codename | Codename of the extension
video  | Video for the extension (HTTP Link)
image | Image for the extension (HTTP Link)
support | Support Link of the extension
documentation | Documentation link of the extension
forum | Link to a forum
mailinglist | Link to a mailing list of the extension
network | Link to networking
created | When has the extension been created
version | Version of the extension
category | 	Category of the extension
download | Link to the extension itself (more on this below)
type | The type of the extension. Is it usable in the Server or Web Administrator. Valid values are: server,web,all - web is default

Here's a sample code for an extensionProvider.cfc:

```lucee
<cfsavecontent variable="desc">
BlogCFM is a totally free, open-source blog application for Lucee.
BlogCFM supports MySQL, PostgreSQL, Microsoft Access and Microsoft SQL Server databases.
* Supports MySQL and SQL Server
* Creates search-engine friendly files for each entry, and for monthly archives
...
* and more!
</cfsavecontent>
<cfset QueryAddRow(apps)>
<cfset QuerySetCell(apps,'id','9')>
<cfset QuerySetCell(apps,'name','blogcfm')>
<cfset QuerySetCell(apps,'type','web')>
<cfset QuerySetCell(apps,'label','BlogCFM')>
<cfset QuerySetCell(apps,'description',desc)>
<cfset QuerySetCell(apps,'author','')>
<cfset QuerySetCell(apps,'codename','')>
<cfset QuerySetCell(apps,'video','')>
<cfset QuerySetCell(apps,'image',rootURL & '/images/blogCFM.gif')>
<cfset QuerySetCell(apps,'support','')>
<cfset QuerySetCell(apps,'documentation','http://www.blogcfm.org/')>
<cfset QuerySetCell(apps,'forum','')>
<cfset QuerySetCell(apps,'mailinglist','')>
<cfset QuerySetCell(apps,'network','')>
<cfset QuerySetCell(apps,'created',CreateDate(2005,1,1))>
<cfset QuerySetCell(apps,'version',"1.14")>
<cfset QuerySetCell(apps,'category',"Blog software")>
<cfset QuerySetCell(apps,'download',rootURL & '/ext/blogcfm/archive.zip')>
<cfreturn apps>
</cffunction>
</cfcomponent>
```

The most important column here is download, since it contains the link to the extension itself. The download file needs to be a zip file that is renamed to .rep (in fact it can be a .zip file as well). The REP file needs to contain the following files:

* **install.cfc**
This file contains the installation methods. See Structure of the extension

* **config.xml**

This file contains the form fields that need to be entered once your extension is installed.

* **zipfile containing your application**

This zip file should contain the root of your extension. It will be unpacked in the install.cfc:install() method.

Next step - [[extension-consumer]]
