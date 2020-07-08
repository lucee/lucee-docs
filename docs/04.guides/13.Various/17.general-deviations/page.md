---
title: General Deviations
id: general-deviations
description: These are general deviations in Lucee that purposely deviate from the CFML Standard.
---

### Custom Tag search path ###

By default Lucee does not search the sub directories of the custom tag paths for a certain custom tag; you can enable that CFML-standard behavior in the Lucee Web or Server Administrators.

### CFC Search Path ###

Lucee does not search for CFC's inside the Custom Tag directory by default, but you can define directories in Lucee Administrator which it should scan for components, so searching the custom tag directories is possible.

### Trusted Cache ###

If the trusted cache is enabled Lucee will not look for any new sourcecode data in the file system. Lucee will always execute the last compiled version of a file. As opposed to the CFML standard, where the trusted cache can only be activated for the complete server, Lucee also offers the trusted cache per single mapping. This is especially useful for applications that use a framework in which the sourcecode does not change, although the application still generates dynamic code. This is a most welcome advantage for several CMS systems.

It is also possible to set custom tag directories and component directories to be trusted. The trusted cache rules apply to them accordingly.

### Lucee Archive ###

Lucee cannot read files that were encrypted by other CFML Engines. In order to nevertheless protect the own Codes Lucee Archive (.ra) can be used. These make it possible to deploy codes ready compiled and in the case of RAS without the initial Source-Code. The only disadvantage of this method is in this case (.ras) errors which showed up during exploration no longer include source information.

### SOAP WebServices ###

Lucee 4 uses [Apache Axis](http://axis.apache.org/axis/) to consume and generate webservices.

Adobe CF uses Axis1 up to version 9, and starting with version 10 it uses both Axis1 and [Axis2](http://axis.apache.org/axis2/java/core/). Therefore consuming SOAP webservices that rely on features supported only by Axis2 will not work.

### Cookies ###

In CF, you can use cookies with complex names and dot notation, for example:
```lucee
    <cfcookie name="person.name" value="wilson, john">
    <cfset cookie.person.lastname="Santiago">
    <cfoutput>#cookie.person.name#</cfoutput>
```

This is a long standing difference between Lucee and ColdFusion and how Lucee is able to keep up the speed in responses.

You will have to change your code in this case because COOKIES.person.name is three levels in a structure in Lucee.

You could change your way of setting it though:

```lucee
<cfset cookie['person.name'] = "Santiago">
```
