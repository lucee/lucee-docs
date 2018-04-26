---
title: Creating an extension installer (4/5)
id: tutorial-extension-provider-part4
---

### Writing an extension - Part 4 - The installer ###

After we have created and validated the configuration data, we should now finally install the software. The install method gives you the possibility to do nearly whatever you like whithin the Railo boundaries. In order to have some support methods available you can extend some existing helper CFC's. These helper CFC's provide some methods to help you create Mappings, Datasources etc. In my particular case I am using the installFolderMapping.cfc helper class. It has the following super methods:

* install
* update

installFolderMapping.cfc extends the CFC InstallSupport.cfc which comes with the following methods:

* updateMapping
* unzip
* removeMapping
* throwErrors

We will publish all helper components with all kinds of support methods so that you only have to extend the corresponding ones in order to have the necessary tools at hand. The install method of the CFC install.cfc gets invoked as soon as the last page of the config.xml form is validated properly. It takes three arguments:

* error
* path
* config

The important ones are path and config. The struct error can be filled in order to throw errors upon install. When you receive the config struct please note that it contains an array with all elements of the corresponding steps and a common struct called mixed that merges all the variables into one struct. If you have ambigous variables (which you anyway should prevent) you can address them over the step array. Now let's look at the install method:

```lucee
<cffunction name="install" returntype="string" output="yes" hint="called from Lucee to install application">
	<cfargument name="error" type="struct">
	<cfargument name="path" type="string">
	<cfargument name="config" type="struct">
	<cfset var sReturn = "">

	<cfset var message=super.install(argumentCollection:arguments)>
	<cfset sReturn = createDatabaseTables(argumentCollection=arguments)>
	<cfif len(trim(sReturn)) eq 0>
	<cfsavecontent variable="sReturn">
	<p>Done!</p><cfoutput><p>You can now start posting from your administration at: 
	<a href="#config.mixed.blog_address#/admin/index.cfm?first=1"]#contractPath(config.mixed.destination_path)#/admin/</a></p>
	<p>Then you can view your blog at: <a href="#config.mixed.blog_address#" target="_blank">#contractPath(config.mixed.destination_path)#</a></p>
	</cfoutput></cfsavecontent>
	</cfif>
	<cfreturn sReturn>
</cffunction>
```

The installer first calls the super.install method that will unzip the files into the destination path. Here's the super.install method:

```lucee
<cffunction name="install" returntype="string" output="no" hint="called from Railo to install application">
	<cfargument name="error" type="struct">
	<cfargument name="path" type="string">
	<cfargument name="config" type="struct">

	<cfzip action = "unzip" destination = "#config.mixed.destination_path#" file = "#path#content.zip" overwrite = "yes" recurse = "yes" storePath = "yes">
	<cfreturn "">
</cffunction>
```

Nothing special here. The next thing that happens then is that the method CreateDatabaseTables is called.

At the end we get the result that Mango has been installed and that we could either follow the link to the administrator or the website itself. We have SUCCEEDED!!! This Method creates the database tables and a datasource in Railo if necessary. So all is in your hand. You can use the tag in order to create necessary entries in the Railo config. The complete extension can be downloaded here.

When the update and uninstall buttons are clicked the corresponding methods get invoked. They always get the complete configuration as an argument, as it was entered when the application was originally installed or updated. So the uninstall method looks like this:

```lucee
<cffunction name="uninstall" returntype="string" output="no" hint="called by Railo to uninstall the application">
	<cfargument name="path" type="string">
	<cfargument name="config" type="struct">
	<cfset arguments.config.path = arguments.config.mixed.destination_path>

	<cfset deleteFiles(argumentCollection=arguments)>

	<cfset dropDatabaseTables(argumentCollection=arguments)>
	<cfreturn "Mango blog has been successfully removed. Tables have beend dropped and the datasource and the corresponding files have been removed.">
</cffunction>
```

Please note that you cannot delete the complete install path if the original install pathe was the webroot itself. There might be  WEB-INF directories in there that either must not be deleted or are not deletable because they are protected (open for read). So mostly the installation is up to you so that you have full control over everything what happens.

The mango blog extension is available from the extension provider - [http://preview.railo.ch/ExtensionProvider.cfc](http://preview.railo.ch/ExtensionProvider.cfc) - if you like to test it. As soon as the Mango team approves the installer we will officially place it on [www.getrailo.org](http://www.getrailo.org/).
