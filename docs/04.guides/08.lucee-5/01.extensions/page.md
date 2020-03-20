---
title: Extensions in Lucee 5
id: lucee-5-extensions
---

# Lucee 5 - Extensions

Creating an extension in Lucee is convention based. A Lucee Extension file is a zip file but with a .lex file extension (e.g. Lucee EXtension) and containing the correct file structure.

The following is a simple example of a Lucee Extension, that we will extend it step-by-step.

## Base structure (required)

At the heart of every extension is the manifest file. This file, `MANIFEST.MF`, is located in the `/META-INF/` folder inside your lex file.

The manifest file is very powerful and we'll start with the base settings you need to have in place. Simply add the following settings to your manifest file.

### Manifest-Version

```luceescript
Manifest-Version: 1.0
```

The manifest version number. This should always be set to the value 1.0 as above.

### ID

```luceescript
id: <uuid>
```

A unique identifier for your extension. The value for the ID has to be a UUID, which you can create with the help of the Lucee function `createuuid`. This identifier will work across multiple extension providers, so if your extension is available on more than one extension provider, Lucee will recognize it and always obtain the newest version.

### Version

```luceescript
version: 1.2.3.4
```

The version number of your extension. Please follow the following pattern for your version number.

&lt;major-number&gt;.&lt;minor-number&gt;.&lt;release-number&gt;.&lt;patches-number-or-string&gt;

### Name

```luceescript
name: Beer
```

This is the name of the extension. You can also add double quotes to your name values to ensure it is interpreted as a string.

These four items are everything we need to have a working extension, so our example `MANIFEST.MF` file now looks like this:

```luceescript
Manifest-Version: 1.0
id: "FAD1E8CB-4F45-4184-86359145767C29DE"
version: "1.2.3.4"
name: Beer
```

Now create a zip file with the file `/META-INF/MANIFEST.MF` in it and then change the file extension of the resulting zip file to '.lex'.

To test your new extension you can either copy it to `/lucee-server/deploy/` a of a running Lucee 5 installation or go into the Lucee Admin (server or web) and upload the file using the option under the `Extension - > Application` section.

If you add the file to the `/lucee-server/deploy/` folder, you might need to wait a little bit, it can take Lucee up to a minute to recognize and install the extension. After the extension disappears from the 'deploy' directory it is installed.

If you now go to the Lucee Server Admin and to the `Extension -> Application` section, you should see it there as installed.

## Base structure (optional)
Now let us make our extension richer by adding some optional settings to the `MANIFEST.MF` file.

## Description

```luceescript
description: "This extension installs a tag, that when used shows you where to have a Beer nearby."
```

The description for your extension.

### Category

```luceescript
category: Fun
```

Category of the extension, this can be a list of multiple categories (comma separated).

### Built date

```luceescript
Built-Date: 2016-02-05 11:39:44
```

Built date of the extension.

### Lucee core version

```luceescript
lucee-core-version: "5.0.0.157"
```

Minimal Lucee core version this extension needs to work properly.

### Lucee loader version

```luceescript
lucee-loader-version: "5.8"
```

The minimum Lucee loader version this extension needs to run properly.

### Release type

```luceescript
release-type: web
```

If this extension should be made available in the server context only, then set to `server`. If this extension only should be available in the web context, then set to `web`. If it should be available in web and server context then set to `all`. The `all` value is the default.

We now have a `MANIFEST.MF` file that covers all the base settings, the extension still does not do anything, but it is now more informative. The manifest file now has this in it:

```luceescript
Manifest-Version: 1.0
id: "FAD1E8CB-4F45-4184-86359145767C29DE"
version: "1.2.3.4"
name: Beer
description: "This extension installs a tag, that when used shows you where to have a Beer nearby."
category: Fun
Built-Date: 2016-02-05 11:39:44
lucee-core-version: "5.0.0.157"
lucee-loader-version: "5.8"
release-type: web
```

Now we create the .lex file with the file `/META-INF/MANIFEST.MF` inside it again and now the extension is ready again.

### Logo

```luceescript
/META-INF/logo.png
```

Adding a logo / icon for your extension is straightforward, simply copy a PNG image file with the name logo.png into the folder `/META-INF/`. This image will be used for the extension in the Lucee Admin.

## Installing artifacts
Now that we have covered how the base settings for an extension work, we can make it do something useful.

To begin with we start by installing some CFML based tags.

### Adding CFML based tags

```luceescript
/tags
```

To add CFML based tags create a directory with the name `/tags` and copy the CFML based tag(s) into this directory. After creating your tag(s), your .lex file (zip) will have the following structure.

```luceescript
/META-INF/MANIFEST.MF
/tags/Beer.cfc
```

Documentation of the tag(s) is via the doc comments and/or hint attributes for the tag. You can add as many tags to the tags directory as you need.

After installing this new extension (see above) you will see in the Lucee admin that the extension is installed and the new tag(s) will now be available.

### Adding CFML based functions

```luceescript
/functions
```

To add CFML based functions create a directory with the name `/functions` and copy a CFML template containing the function to that directory. After creating your function(s), your .lex file (zip) will have the following structure.

```luceescript
/META-INF/MANIFEST.MF
/tags/Beer.cfc
/functions/beer.cfm
```

Documentation of the function(s) is via the doc comments and/or hint attributes for the function. You can add as many functions to the functions directory as you need.

After installing this new extension (see above) you will see in the Lucee admin that the extension is installed and the new function(s) will now be available.

### Install context files

```luceescript
/context
```

The `context` files are files that are copied to the Lucee context directory. This directory is available via the mapping `/lucee` in the case of a web context extension (see `release-type` above) or `/lucee-server` in the case of a server context extension.

The `context` file can be used for various things:

* make a web service available
* make a component available
* extend the Lucee admin with a plugin (by using the path /context/admin/plugin/MyPlugin)
* extend the Lucee admin with a JDBC Driver (by using the path /context/admin/dbdriver/MyDB.cfc)
* extend the Lucee admin with a cache (by using the path /context/admin/cdriver/MyCache.cfc)
* extend the Lucee admin with a debug template (by using the path /context/admin/debug/MyDebugTemplate.cfc)

The content of the extensions `context` folder could look something like this:

```luceescript
/META-INF/MANIFEST.MF
/context/admin/plugin/NotePlus/Action.cfc
/context/admin/plugin/NotePlus/language.xml
/context/admin/plugin/NotePlus/overview.cfm
```

#### Web Contexts Files

```luceescript
/webcontexts
```

These are similar to the `context files`, the difference being that `context files` only define context files for the current context (server or web). The web contexts files however are used in a server context extension to install files to ALL existing and upcoming web contexts. This means that when you add a new web context after this extension is installed, the files defined in this folder will be available to this new web context.

The content of the extensions `webcontext` files could look something like this:

```luceescript
/META-INF/MANIFEST.MF
/webcontexts/admin/debug/MyDebugTemplate.cfc
```

#### Applications

```luceescript
/application
```

If this extension is installed in a web context the content of this folder is copied to the web root directory of that context.

The content of the extensions `application` folder could look something like this:

```luceescript
/META-INF/MANIFEST.MF
/applications/Application.cfc
/applications/index.cfm
```

#### Plugins

```luceescript
/plugins
```

Installs content from the folder `/plugin` to the plugin directory of the server or web context.

This is a shortcut for `/context/admin/plugin` (see above).

The content of the extensions `plugin` folder could look something like this:

```luceescript
/META-INF/MANIFEST.MF
/plugins/NotePlus/Action.cfc
/plugins/NotePlus/language.xml
/plugins/NotePlus/overview.cfm
```

You can read more about creating plugins in our guide for [[plugins]]

#### Archives

```luceescript
/archives
```

The folder `/archives` is used to install regular, component or custom tag archives. Lucee archives can be generated in the details view of regular, component or custom tag mappings in the administrator.

The content of the extensions `archives` folder could look something like this:

```luceescript
/META-INF/MANIFEST.MF
/archives/myapp.lar
/archives/mycomponents.lar
/archives/mycustomtag.lar
```

#### JARs

```luceescript
/jars
start-bundles:true
```

Many Lucee extensions use Java libraries (jars) to work.

Lucee 5 support `classic` Jars and OSGI bundles (a subset of jars). Lucee will detect if the given input is a `classic` jar or an OSGi bundle and handle the file accordingly.

#### OSGi Bundles

OSGi is the framework Lucee 5 is based on, that allows for the loading and unloading of JAR files on the fly at any time without a server restart being required. In addition you can have different versions of the same JAR in your environment without causing a conflict.

The term `Installing an OSGi bundle` is not accurate in this context, adding a bundle to the JARs directory makes the bundle available in the environment but does not `install` it.

To make Lucee load (install) the JARs into the environment you need to define the setting `start-bundles` in the Manifest file, but in many cases this is not necessary, for example when your JAR contains a tag that you are defining in a tld, you simply define the bundle name and version with the class definition and Lucee will load the JAR automatically when required. This has the benefit that bundles are only loaded into the memory when used.

*Please note:* It is not actually necessary to bundle the OSGi bundle with the extension, if Lucee cannot find the OSGi bundle locally, Lucee will attempt to download it from the update provider (when available).

#### Classic JAR

Any JAR that is not an OSGi bundle is considered to be a classic JAR. It is highly recommended that they are not used, however, it is possible to use them but they have downsides.

For example under MS Windows it is not possible to update an already loaded JAR, because Windows has a lock on that JAR. Every update to a "classic" JAR requires a restart of the whole Lucee server.

The content of the extensions `jars` folder could look something like this:

```luceescript
/META-INF/MANIFEST.MF
/jars/mybundle.jar
```

#### Components

```luceescript
/components
```

You can make components globally available by adding them to the folder `/components`.

The content of the extensions `components` folder could look something like this:

```luceescript
/META-INF/MANIFEST.MF
/components/org/lucee/my/com/MyComp.cfc
```

## Installing

Now that we have looked at how to install artifacts and configure base settings, we will explain how to install specific functionality to extend Lucee.

### Resources (Virtual file system)

```luceescript
resource:{...}
```

Lucee has an interface to install a virtual file system that can be used in every aspect of the language.

Lucee support a Java and a CFML interface for virtual file systems, so a virtual filesystem can be written in either Java or CFML.

However the installation of a Java based virtual file system is different to the installation of a CFML based virtual file system, therefore we will cover these 2 things separately.

#### Java based Virtual File System

For a Java virtual file system we need to register the class that implements the interface `ResourceProvider`, to do this we add the following setting to the `MANIFEST.MF` file:

```luceescript
resource:"[{
'class':'my.very.special.fs.WhateverProvider',
'bundleName':'my.whatever',
'bundleVersion':'1.2.3.4',
'scheme':'we',
'lock-timeout':'10000'
}]"
```

We define this setting as a JSON String. We define the class that implements the ResourceProvider and the bundle name and version. In addition we can also define other settings such as `lock-timeout`, in the case above. All of these configuration settings are simply forwarded to the `init` method of the class defined.

Copy the OSGi bundle (JAR) containing your ResourceProvider to the `/jars` folder in your extension. It is not necessary to load the JAR with the help of the `start-bundles` setting, Lucee will find the JAR with the help of the bundle definition and only load it as required.

#### CFML based Virtual File System

For CFML based virtual file systems we need to register the Resource Provider as well, but this time as a CFML component, add something like the following to the `MANIFEST.MF` file:

```luceescript
Resource:"[
{'component':'my.very.special.fs.WhateverProvider'
,'scheme':'we',
'lock-timeout':'10000'
}]"
```

Now we have to make that component available for Lucee, there are two ways to do this. You can make the component available as part of a component archive (see `Archives` above) or you simply add the component to the `/components` folder (see `Components` above).

Example implementation:

[https://github.com/lucee/extension-s3](https://github.com/lucee/extension-s3)

### Mapping

```luceescript
mapping:[]
```

You can define mappings that point to files, archives or virtual file systems you are installing. You can define as many mappings as you need by adding something like the following to the `MANIFEST.MF` file:

```luceescript
mapping: "[
{
'virtual':'/org/lucee',
'physical':'https://lucee.org',
'inspect':'never'
},
{
'primary':'archive',
'virtual':'/myApp',
'toplevel':true,
'archive':'/../myapp.lar'
}]"
```

### JDBC

To install a JDBC Driver, add the following setting to the `MANIFEST.MF` file:

```luceescript
jdbc: "[{
'label':'${label}',
'class':'${className}',
'bundleName':'${symbolicName}',
'bundleVersion':'${symbolicVersion}'
}]"
```

Copy the OSGi bundle (JAR) containing your JDBC to the `/jars` folder in your extension. It is not necessary to load the JAR with the help of the `start-bundles` setting, Lucee will find the JAR with the help of the bundle definition and only load it as required.

Example implementation:

[https://github.com/lucee/JDBC-extension-factory](https://github.com/lucee/JDBC-extension-factory)

### Search

Installing a Search Engine.

To install a search engine you need to register the class that implements the interface `lucee.runtime.search.SearchEngine`, to do this we add the following setting to the `MANIFEST.MF` file:

```luceescript
search: "[{
'class':'${class}',
'bundleName':'${bundlename}',
'bundleVersion':'${bundleversion}${build.number}'
}]"
```

Copy the OSGi bundle (JAR) containing your Search Engine implementation  to the `/jars` folder in your extension. It is not necessary to load the JAR with the help of the `start-bundles` setting, Lucee will find the JAR with the help of the bundle definition and only load it as required.

Example implementation:

[https://github.com/lucee/extension-lucene](https://github.com/lucee/extension-lucene)

### ORM

To install an ORM Engine you need to register the class that implements the interface `lucee.runtime.orm.ORMEngine`, to do this we add the following setting to the `MANIFEST.MF` file:

```luceescript
orm: "[{
'class':'${class}',
'name':'${bundlename}',
'version':'${bundleversion}${build.number}'
}]"
```

Copy the OSGi bundle (JAR) containing your ORM Engine implementation to the `/jars` folder in your extension. It is not necessary to load the JAR with the help of the `start-bundles` setting, Lucee will find the JAR with the help of the bundle definition and only load it as required.

Example implementation:

[https://github.com/lucee/extension-hibernate](https://github.com/lucee/extension-hibernate)

Java based Tag/Function (TLD/FLD)

```luceescript
/jars
/tlds
/flds
```

Installing one or multiple Java based tags or functions. Installing a tag or a function is the same process, because of that we handle these two topics together. A Java based tag/function needs two things:

1. An OSGi Bundle (JAR) containing the class that implements the interface `javax.servlet.jsp.tagext.Tag` for tags and/or `lucee.runtime.ext.function.BIF` for a function.
2. A tld/fld file that contains the description of one or multiple of the tags/functions.

So copy the OSGi bundles to the folder `/jars` and the tld/fld file to the folder `/tlds` or `/flds`.

*Side note:* For TLD files please use the extension `.tldx`, otherwise it can break Tomcat when it attempts to read the `.tld` file. Lucee can handle the extensions `.tld` and `.tldx`, and Tomcat will ignore `.tldx`.

Example implementation:

[https://github.com/lucee/extension-pdf](https://github.com/lucee/extension-pdf)

### Monitor

Install a Monitor (more detailed documentation will follow).

```luceescript
monitor: "[{
  'name':'${actionMonitorName}',
  'type':'${actionMonitorType}',
  'class':'${actionMonitorClass}',
  'bundleName':'${bundlename}',
  'bundleVersion':'${bundleversion}${build.number}'
},
{
  'name':'${intervalMonitorName}',
  'type':'${intervalMonitorType}',
  'class':'${intervalMonitorClass}',
  'bundleName':'${bundlename}',
  'bundleVersion':'${bundleversion}${build.number}'
},
{
  'name':'${requestMonitorName}',
  'type':'${requestMonitorType}',
  'class':'${requestMonitorClass}',
  'bundleName':'${bundlename}',
  'bundleVersion':'${bundleversion}${build.number}'
}]"
```

### Cache Handler

This has nothing to do with installing a `Cache` like `EHCache`, this extends the functionality of all `cachedwithin` attributes in Lucee.

The Lucee core supports two cache handler types out of the box:

1. Time span cache, e.g. `cachewithin=createTimeSpan(0,0,0,10)`
2. Request span cache, e.g. `cachewithin="request"`

So with this option you can extend this functionality.

To install a Cache Handler you need to register the class that implements the interface `lucee.runtime.cache.tag.CacheHandler`, to do this we add the following setting to the `MANIFEST.MF` file:

```luceescript
cache-handler: "[{
  'id':'smart',
  'class':'${class}',
  'name':'${bundlename}',
  'version':'${bundleversion}'
}]"
```

Copy the OSGi bundle (JAR) containing your Cache Handler implementation to the `/jars` folder in your extension. It is not necessary to load the JAR with the help of the `start-bundles` setting, Lucee will find the JAR with the help of the bundle definition and only load it as required.

### AMF (Flex)

To install an AMF Engine you need to register the class that implements the interface `lucee.runtime.net.amf.AMFEngine`, to do this we add the following setting to the `MANIFEST.MF` file:

```luceescript
amf: "{
  'class':'${class}',
  'bundleName':'${bundlename}',
  'bundleVersion':'${bundleversion}',
  'caster':'modern',
  'configuration':'manual'
}"
```

Example implementation:

[https://github.com/lucee/extension-flex](https://github.com/lucee/extension-flex)

### Event Handler
(TODO)

### Event Gateway
[[event-gateways]]
