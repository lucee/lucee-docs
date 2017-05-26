---
title: Updating Tomcat's Server.xml File
id: windows-updating-tomcat-server-xml-file
---

As of Lucee 3.3.2 and the addition of mod_cfml into the default installation of the Lucee Installers, you are no longer required to add site configurations to the Tomcat server.xml file, but you still can if you would like to. Adding a site config to Tomcat's server.xml file will save the context from having to be created on a server restart. This can increase response time of your sites especially after a server restart. The performance gains are minimal, however, so if you chose to not configure sites in the Tomcat server.xml file, it's not a big issue.

Adding Hosts and Contexts

By default, the Tomcat server.xml file can be found at the following URL:

	C:\railo\tomcat\conf\server.xml 

Open the file in notpad (you don't want additional formatting characters in there) and scroll to the bottom, where you will see something similar to the following:

```lucee
< !--
     Add additional VIRTUALHOSTS by copying the following example config:
     REPLACE:
     [ENTER DOMAIN NAME] with a domain, IE: mysite.com
     [ENTER SYSTEM PATH] with your web site's base directory. IE: /home/user/mysite.com/ or C:\websites\mysite.com\ etc...
     [ENTER ALIAS DOMAIN] with a domain alias, like www.mysite.com (This is an optional parameter)
     Don't forget to remove comments! ;)
 -->
 < !--
     <Host name="[ENTER DOMAIN NAME]" appBase="webapps"
          unpackWARs="true" autoDeploy="true"
          xmlValidation="false" xmlNamespaceAware="false">
          <Context path="" docBase="[ENTER SYSTEM PATH]" />
          <Alias>[ENTER ALIAS DOMAIN]</alias>
     </host>
 -->
  </engine>
 </service>
</server>
```

Just copy the example entry and match up the two areas in square brackets with real information. Something like this:

```lucee
<Host name="getrailo.org" appBase="webapps"
     unpackWARs="true" autoDeploy="true"
     xmlValidation="false" xmlNamespaceAware="false">
     <Context path="" docBase="/home/railo/getrailo.org/" />
</Host>
```

If this domain can be found using more then one domain, just add an alias entry, like this:

```lucee
<Host name="getrailo.org" appBase="webapps"
	unpackWARs="true" autoDeploy="true"
	xmlValidation="false" xmlNamespaceAware="false">
	<Context path="" docBase="/home/railo/getrailo.org/" />
	<Alias>www.getrailo.org</alias>
	<Alias>web.getrailo.org</alias>
	<Alias>railo.ch</alias>
	<Alias>www.railo.ch</alias>
</host>
```

**IMPOARTANT:** Wildcards are NOT currently supported by . So, the following will NOT work:

	<Alias>*.getrailo.com</alias> #WILL NOT WORK 

After you've updated the server.xml file, you will need to restart Lucee/Tomcat in order for the changes to take effect.

### Using Shortcuts ###

If you've got a shortcut set up in your site, where maybe c:\inetpub\mysite.com is just a shortcut to c:\websites\mysite.com, and you want Tomcat to follow the shortcut and pretend it's like any other directory, DON'T DO IT! While it is technically possible to tell Tomcat to follow shortcuts, it opens up a potential security risk that will enable the bad guys to view source code. You do not want to do this.