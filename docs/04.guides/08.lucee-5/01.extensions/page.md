---
title: Extensions in Lucee 5
id: lucee-5-extensions
---

# Lucee 5 Extension Framework #
**Lucee 5 has had a complete overhaul of the existing extension framework, to make them more flexible and easier for everyone to create extensions.**

Lucee already had support for extensions and extensions could be Java and / or CFML based applications that could be installed inside the Lucee Administrator but this feature was not as well adopted by the community as we would have liked. The main reason for this was the lack of documentation and the complexity of creating an extension. With the launch of Lucee 5 we will change this, removing the complexity and creating detailed documentation. Also extensions will be "convention based" and have complete OSGi support removing the risk of library conflicts.

## Different ways to install ##
In Lucee 4 you could only install extensions via the administrator however in Lucee 5 you can install extensions in the following ways:

**Administrator**

You can still install extension in the administrator as you could before.

**Deploy Folder**

Lucee 5 extensions have the file extension ".lex" and you can install these by copying ".lex" files into the folder `{server|web-context}/deploy` and Lucee will pick them up and install them automatically.

**JVM Argument**

You can install extensions by declaring the "id" of the extension as a JVM argument in the startup script. The following is an example for installing the MySQL and the MSSQL Datasource driver

```
-Dlucee-extensions=99A4EF8D-F2FD-40C8-8FB8C2E67A4EEEB6;7E673D15-D87C-41A6-8B5F1956528C605F
```

## Convention Based ##
The "convention based" approach means you simply have folders for different parts of your application, for example:

- /applications - for cfm & cfc files that need to be installed in the webroot
- /functions - for built-in functions to install
- /jars - for libraries used by your extension
- /plugins/{plugin name}/* - for adding an admin plugin

The complete list of directories and file extensions which you can add to a .lex archive is (distilled from [the source code](https://github.com/lucee/Lucee/blob/master/core/src/main/java/lucee/runtime/config/XMLConfigAdmin.java#L4527)):
`/jars/*.jar`
`/jar/*.jar`
`/bundles/*.jar`
`/bundle/*.jar`
`/lib/*.jar`
`/libs/*.jar`
`/flds/.../*.fld`
`/tlds/.../*.tld`
`/archives/.../*.lar`
`/mappings/.../*.lar`
`/event-gateway/.../*.cfc|*.lucee`
`/eventGateway/.../*.cfc|*.lucee`
`/tags/*`
`/functions/*`
`/context/*`
`/webcontexts/*`
`/applications/*`
`/plugins/*`

This means that creating an extension for Lucee 5 is as simple as adding the stuff you need into certain folders, zipping it up and letting Lucee take care of the rest.

## OSGi Support ##
The "OSGi support" means that Lucee makes sure that the jars you install are OSGi bundles and if they are not it converts them to OSGi bundles on the fly. 

**Please note:** This only applies to JARs that are bundled with extensions and is not 100% guaranteed to work everytime. It is best practice for you to convert any JARs to OSGi before hand. Also, this automatic conversion to OSGi only occurs for JARs that come with an extension and not for JARs dropped into the Lucee bundles directory.

## But what if I have to define / check preconditions / relations? ##
Every extension also needs a "META-INF/Manifest.mf" file, where you need to define certain settings, the following example is the content from the manifest file for the MongoDB extension:

```
Manifest-Version: 1.0
Built-Date: 2015-03-11 16:11:16
version: "1.0.0.40"
id: "E6634E1A-4CC5-4839-A83C67549ECA8D5B"
name: "MongoDB Datasource and Cache"
description: "This Extensions allows to use MongoDB direcly in your code or as a Cache (Experimentel). MongoDB (from humongous) is a cross-platform document-oriented database. Classified as a NoSQL database, MongoDB eschews the traditional table-based relational database structure in favor of JSON-like documents with dynamic schemas (MongoDB calls the format BSON), making the integration of data in certain types of applications easier and faster."
start-bundles: false
trial: false
lucee-core-version: "5.0.0.021"
```

In this case, for example, we have defined that Lucee "5.0.0.021" is necessary to install this extension.

## Install script no longer required ##
With pre-Lucee 5 extensions you had to create an install.cfc file and code the installation of the extension yourself, however with Lucee 5 this script is no longer required and Lucee now takes care of the install for you.
