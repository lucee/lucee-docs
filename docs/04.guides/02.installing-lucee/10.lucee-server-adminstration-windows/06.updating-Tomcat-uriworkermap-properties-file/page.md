---
title: Updating the uriworkermap.properties File
id: windows-updating-uriworkermap-properties-file
---
**NOTE:** This information is only relevant for Lucee 3.3.2 and BELOW. Newer releases of the Lucee Installer come with the improved BonCode Connector which does not require a workermap.

The uriworkermap.properties file is what tells the IIS connector what requests to hand off to Tomcat for processing. You will need to edit this URL if IIS is not passing off a request to Tomcat that you want passed (like a specially formatted search engine optimized URL), or if IIS is passing a request that you do NOT want passed off to Tomcat (like a file that needs to be processed by a different language interpreter, such as PHP, ASP, or Ruby).

The default location for the uriworkermap.properties file is here:

	C:\lucee\tomcat\conf\uriworkermap.properties

### URL Pattern Formatting ###

Each line in the uriworkermap.properties file constitutes a pattern that the connector needs to watch for and where to send it to when it sees that pattern. Take, for example, the following pattern:

	 /=ajp13

The "/" is the URL pattern, and the "ajp13" is the Tomcat instance to send it to. This particular entry is specially created for processing the index.cfm file as a default document. When IIS gets a request for a site, like for <http://www.lucee.org/>, the URL pattern at the end (after the domain itself) is a simple "/", which is going to get passed off to Tomcat because of the config in the uriworkermap.properties file.

### Wildcards ###

The uriworkermap.properties file includes support for asterisk (*) wildcards to be included in the URL patterns to be passed off to Tomcat. This is nice because it makes adding URL patterns infinitely easier then adding them all separately. The following URL pattern is a good example:

```lucee
/*.cfm=ajp13
```

In this example, any URL pattern that ends in .cfm will be passed to Tomcat.

### Exclusions ###

Occasionally you may find a situation where a URL pattern is being passed to Tomcat that you do not want to get passed there. To correct this, you can add exclusions to your uriworkermap.properties file. The following is an example of an exclusion:

	!/*.asp=ajp13

The above command will ensure that no URL that ends in .asp will be passed to Tomcat for processing.