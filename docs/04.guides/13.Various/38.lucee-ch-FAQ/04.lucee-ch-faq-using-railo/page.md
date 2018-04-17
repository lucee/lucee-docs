---
title: Lucee Web and Server Admin Urls
id: lucee-ch-faq-using-lucee
---

**What's the URL of the Web Administrator?**

The Lucee Web Administrator is found at [http://localhost:8888/lucee/admin/web.cfm](http://localhost:8888/lucee/admin/web.cfm). (you can replace localhost:8888 with your website's host name, the port 8888 is the default port for Tomcat and is not required when accessing your Web Administrator via your webserver).

For security it's __highly recommended__ to [[cookbook-lockdown-guide|lockdown]] this directory via your web server configuration.

**What's the URL of the Server Administrator?**

The Lucee Server Administrator is found at [http://localhost:8888/lucee/admin/server.cfm](http://localhost:8888/lucee/admin/server.cfm) in a browser (you can replace localhost:8888 with your website's host name and port).

Like the Web Administrator, the Server Administrator can be called from each website. In the upper right corner of the Administrationarea is a link to the corresponding administrator. There is a link in the Web Administrator to the Server Administrator and vice versa. 

That is why it's important to [[cookbook-lockdown-guide|lockdown]] the admin directory for all your websites served by Lucee.

**What's the difference between the Web and the Server Administrator?**

The Web Administrator defines local Settings for a website context and the Server Administrator the global default values for the Lucee installation. In addition the Server Administrator allows you to manage passwords for each website context, under Security.

Global services like mappings, customtags, datasources etc. can be defined globally so that all webs have access to them. In the local Web Administrators global services can not be deleted, they are readonly.

The Server Administrator can be used for restarts of the Lucee engine as well as for applying updates.

**In the documentation you sometimes refer to something called a "Lucee web". What do you call a "Lucee web"?**

In terms of Lucee, a web is similar to a webroot directory, it's also called a context. Each Lucee web context has it's own /WEB-INF/ directory in which the individual settings for that website are stored. 

Every web context has its own /WEB-INF/lucee/lucee-web.xml file which contains all Administrator settings for this particular web context. Lucee webs should not be confused with "virtual hosts" although they are similar. 

More than one virtual host can point to the same webroot. So a Lucee context can be reached by more than one "virtual host". 

Lucee creates a separate web context for each hostname. Every website context Lucee is configured to serve has it's own Web Administrator which allows you to set up and configure different datasources, mappings, debug-settings etc 

Default and global values for all web contexts can be defined using the Server Administrator. So for instance you can define a datasource available for all Lucee websites.

What settings are advisable for me as a hoster in order to achieve the highest security level?

The following settings grant maximum security for hosters:

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
