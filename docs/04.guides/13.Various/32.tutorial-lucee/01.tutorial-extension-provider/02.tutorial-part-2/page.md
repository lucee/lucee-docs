---
title: Creating an extension (2/5)
id: tutorial-extension-provider-part2
categories:
- extensions
---

### Creating an extension - Part 2 ###

In the first part of the tutorial entry we created an extension provider for a local context which we can use in order to create our extension of choice Mango Blog. This entry will cover the collection of the necessary data in the config.xml file which is part of the installation repository.

### Creating the data collection form ###

In order to collect user data, you can create a config.xml which is part of the provided repository and contains elements that define the form displayed. There are several different elements that can be used. In order to check what elements you can use and especially what the allowed attributes are, just check our documentation wiki.

The data collection form for Mango blog looks like this:

```lucee
 <?xml version="1.0" encoding="iso-8859-1"?>
    <config>
    <step label="Step 1" description=" You are about to install Mango Blog. You will need to have a database (MS SQL or MySQL) already created (it can be an empty database). ">
        <group label="Location" description="Please set the location where you want to install Mango blog to">
            <item type="text" name="destination_path" description="path where Mango blog should be installed into">evaluate:expandPath('/mango/')</item>
        </group>
        <group label="Existing Database" description="Choose from an existing datasource. If your hosting provider requires you to supply username and password every time you need to access your database, fill out the corresponding fields.">
            <item type="radio" name="datasource_select" description="You can select a new datasource from the dropdown below">
                <option value="existing" description="">Choose existing database</option>
            </item>
            <item dynamic="listDatasources" label="Datasources" name="datasource" type="select" description="This the Data Source Name (DSN) created for Mura. This is usually done in the ColdFusion or Lucee administrator, or in the control panel of your host if you are installing Mura in a shared environment. Please note that if you are installing Mura in a shared environment, this will likely need to be changed to something other than 'muradb' to make sure it is unique to the server. You can use either MSSQL, MySQL or H2SQL Databases, please select one of your databases"/>
            <item type="text" name="db_username" label="Username" description="Username to access your database"/>
            <item type="text" name="db_password" label="Password" description="Your database password"/>
        </group>
        <group label="New Datasource" description="Create a new datasource">
            <item type="radio" name="datasource_select" description="Provide the necessary data in order to create the corresponding data">
                <option value="new" description="">Create new datasource</option>
            </item>
            <item type="text" name="datasource_new" value="mangoblog" label="Datasource name (required)"/>
            <item type="radio" label="Choose DB Type" name="dbtype_new">
                <option value="mssql" description="">MS SQL 2000</option>
                <option value="mssql_2005" description="">MS SQL 2005</option>
                <option value="mysql" description="" selected="true">MySQL</option>
            </item>
            <item type="text" name="server_new" value="localhost" label="Database server" description="Your database host address (i.e.: localhost, an ip address or url)"/>
            <item type="text" name="database_new" value="mangoblog" label="Database name" description="The name of your database"/>
            <item type="text" name="username_new" value="root" label="Username" description="Username to access your database"/>
            <item type="password" name="password_new" value="admin" label="Password" description="Your database password"/>
            <item type="text" name="prefix_new" label="Table prefix" description="Fill this if your database is not empty or you have another Mango installation in the same database"/>
        </group>
    </step>
    <step label="Step 2" description="New blog?">
        <group label="Is this a new blog" description="">
            <item type="radio" name="isblognew" description="You can import your blog entries from another blog. At the end of the installation process the importer will be started.">
                <option value="no" description="">No</option>
            </item>
        </group>
        <group label="Author information" description="Information about the blog author">
            <item type="radio" name="isblognew" value="yes">
                <option value="yes" description="">Yes</option>
            </item>
            <item type="text" name="name" label="Name"/>
            <item type="text" name="username" value="" label="Username"/>
            <item type="password" name="password" label="Password"/>
            <item type="text" name="email" label="Email" description="Email address where password will be sent if forgotten. This address also identifies the author when writing comments in posts."/>
        </group>
        <group label="Blog information" description="Describe your blog">
            <item type="text" name="blog_title" label="Title"/>
            <item type="text" name="blog_address" label="Blog address">evaluate:'http://#cgi.http_host#/'</item>
        </group>
    </step>
    </config>
```

As you can see the above code uses a notation similar to creating forms in HTML. Please check the reference in the wiki in order to find out what you can do with the different tags available. The only special thing here is the line:

```lucee
<item dynamic="listDatasources" label="Datasources" name="datasource" type="select" description="This ... databases"/>
```

This calls the method listDatasources in the install.cfc in order to create the options of the select box. This method looks like this:

```lucee
<cffunction name="listDatasources" returntype="void" output="no" hint="called from form generator to create dynamic forms">
    <cfargument name="item" required="yes" hint="item cfc">
    <cfset var type="">
    <cfadmin action="getDatasources" type="#request.adminType#" password="#session["password"&request.adminType]#" returnVariable="datasources">
    <cfloop query="datasources">
        <cfif findNoCase('microsoft',datasources.classname ) or findNoCase('jtds',datasources.classname )>
            <cfset type="mssql">
        <cfelseif findNoCase('mysql',datasources.classname )>
            <cfset type="mysql">
        <cfelse>
            <cfcontinue>
        </cfif>
        <cfset item.createOption(value:type&":"&datasources.name,label:datasources.name&" ("&datasources.host&")")>
    </cfloop>
    <cfset item.createOption(value:"new",label:"Create new one")>
</cffunction>
```

The above config.xml produces the following forms:

License: If there is a license.txt file in your archive.zip it automatically gets displayed. This is the first page.

[[tutorial-extension-provider-part3]]
