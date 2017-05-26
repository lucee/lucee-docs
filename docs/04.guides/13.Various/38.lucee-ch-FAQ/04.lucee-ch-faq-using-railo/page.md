---
title: Using Lucee
id: lucee-ch-faq-using-lucee
---

**What's the URL of the Web Administrator?**

From each webroot the web administrator is reachable at http://webroot/lucee-context/admin/web.cfm.
But you can not call http://webroot/lucee-context/ since lucee-context is a mapping in Lucee and the mapping is not known by the webserver. So you always have to call the .cfm file.

**What's the URL of the Server Administrator?**

Like the Web Administrator the Server Administrator can be called from each web. In the upper right corner of the administration area there is a link to the corresponding administrator. On the area of the Web Administrator you will find the link to the Server Administrator and vice versa. The administrator can be called directly by entering the address http://webroot/lucee-context/admin/server.cfm in a browser.

What is the difference between the Web and the Server Administrator?

The Web Administrator defines local Settings for a web and the Server Administrator the global default values. In addition the Server Administrator (in the Enterprise and Developer version) allows you to set authorizations for the Web Administrator of all single webs. 
In here global services like mappings, customtags, datasources etc. can be defined globally so that all webs have access to them. In the local Web Administrators global services can not be deleted, they are readonly.
In the Professional and Community like in all other version the Server Administrator can be used for restarts of the engine as well as for updates.

In the documentation you sometimes refer to something called a "Lucee web". What do you call a "Lucee web"?

In terms of Lucee, a web is similar to a webroot directory. Each Lucee web contains its own WEB-INF directory in which all individual web settings are stored. Every web has its own lucee-web.xml file which contains all administrator setting for this particular web. 
Lucee-webs should not be confused with "virtual hosts" all though the are similar. More than one virtual host can point to the same webroot directory. So a Lucee web can be reached by more than one "virtual host". 
Lucee is able to separate webs logically. This means that you have your own local web administrator for each of the Lucee webs. With the help of this web administrator you can set up different datasources, mappings, debug-settings etc. for each individual web. And they can differ from web to web. 
Default and global values for all webs can be defined using the server administrator. So for instance you can define a datasource available for all Lucee webs.

What settings are advisable for me as a hoster in order to achieve the highest security level?

The following settings grant maximum secutity for hosters:

Setting | Value
------ | ------
Server | settings (Regional, Components, Scope)	Off
Mail |	Off (global mailserver)
Datasources	| 0 (or the smallest value for a standard web)
Mappings |	Off
Custom Tags | Off
CFX-Tags |	Off
Debugging |	On
File access | None
Direct Java access | Off
Tag CFEXECUTE |	Off
Tag CFIMPORT |	Off
Tag CFOBJECT / Function CreateObject |	Off
Tag CFREGISTRY | Off
CFX tags |	O

Per web you still can define individual settings. But when using the above default settings you host safely.

**Can I only use the datasource types listed in the web administrator Drop-Down?**

No, on one hand you can use any JDBC-driver by choosing other in the database type Drop-Down and provide the class of the used database driver. 

And on the other hand you can enlarge the Drop-Down by implementing your own driver. This has to be done like follows: 
In the folder /WEB-INF/lucee/context/admin/dbdriver/ the drivers for the available datasource types are located in a cfc. Just copy one of these drivers and customize it the way you need it. 
All drivers inherit the component driver.cfc, which is located in this directory, too.
If you're looking for a certain driver, ask us. We would be glad to help you.

