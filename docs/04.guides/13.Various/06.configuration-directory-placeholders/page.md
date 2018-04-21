---
title: 'Configuration: Lucee Directory Placeholders'
id: configuration-directory-placeholders
menuTitle: Directory Placeholders
---

## Directory Placeholders ##

In order to make configuring Lucee a little easier, there are several constants (we call them "directory placeholders") that contain a certain value which might change depending on the system, the environment or the context.

### Available Directory Placeholders ###

Here are the available placeholders in Lucee:


Directory Placeholder         |    	Description                                                            |
------------------------      | --------------------------------------------
{lucee-web}                   | Path to the Lucee web directory, usually {web-root}/WEB-INF/lucee.         |
{lucee-server}                | Path to the Lucee server directory, usually where the lucee.jar is located |
{lucee-config}                | This is the same as {lucee-server} in server context and the same as {lucee-web} in web context. |
{temp-directory}              | Path to the temp directory of the current user of the system. |
{home-directory}              | Path to the home directory of the current user of the system. |
{web-root-directory}          | Path to the web root.                                         |
{system-directory}            | Path to the system directory.                                 |
{web-context-hash}            | Hash of the web context.                                      |
{web-context-label}           | A label for the web context. See A note on {web-context-label} below. |

## Directory Placeholders in CFML  ##

You can reference the directory placeholders in your CFML code like this:

```lucee
<cfdump var="#expandPath('{lucee-web-root}')#">
```

## A note on {web-context-label} ##

If you have configured Lucee to generate the configuration directories using the {web-context-hash}, you may have wished that the resulting hashed directories were a little more readable. You'll end up with a list of directories named with a hash value that is 32 bytes long. This is far from readable.

Therefore, in Lucee 3.3, we introduced a new directory placeholder: {web-context-label}. Now you have the opportunity to use a label as a path to the configuration files for each web context. In order to use this label, you need to define it in every lucee-web.xml.cfm in every configuration directory.

As of Lucee 4.0.2.002 final, you can update the {web-context-label} through the Server Administrator. After you've logged in to [domain]/lucee-context/admin/server.cfm, you will see a section marked "Web Contexts" at the bottom of the page. Here you can modify your labels and click the update button to save the changes.
