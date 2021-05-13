---
title: Server 2008 with Tomcat and Plesk
id: server-2008-IIS-7.5
---

### Setting up Lucee with Tomcat on Server 2008 R2, IIS 7.5 and Plesk ###

The following is an edited version of an original post | [Installing Lucee and Tomcat on Windows Server 2008 R2 IIS 7.5 with Plesk - The correct way](https://sidfishes.wordpress.com/2011/09/13/installing-railotomcat-in-windows-server-2008-r2-iis-7-5-with-plesk-the-correct-way/)

There are 2 things (at minimum!) that can cause problems installing to this configuration; Plesk and confusion (or IIS 7.5 lack of clarity) as to what Enable 32 Bit Applications means. Plesk does quite a few funky things to IIS since it is a web based management tool. Much grief stems from the fact that Plesk is a 32 bit App and a Server 2008 R2 install is 64 bit (and only 64 bit). Plesk also uses but doesn't expose a version of Tomcat. The Lucee Tomcat instance may install itself on a different port than normal due to the Plesk instance. Now we don't want to break Plesk so we need a procedure to make it play nice and undo some of the problems it causes with IIS. The following outlines the steps needed to get Plesk, Lucee, Tomcat & IIS 7.5 all running happily.

This walkthrough assumes you have already set up a single website using Plesk. I'm assuming Plesk operates pretty much the same on all II 7.5 setups so it should be pretty standard.

### Fixing what Plesk Hath Wrought ###

Once we've created our website via the Plesk panel we need to go and make some changes in IIS so fire up INETMGR

Select Application Pools under the main node of your site. You'll notice there a couple of the standard and a couple added by Plesk.

Click Set Application Pool Defaults from the right column. Here we see that Plesk has set Enable 32 Bit Applications to True. We need to set this to false.

It's important here to have a clear understanding as to what Enable means. For IIS 7.5, Enable means Only Allow. So If you have this set in Application Pool Defaults IIS will create all new AppPools with 32 bit enabled preventing 64 bit apps from running. When trying to run a 64 bit app with 32 bit enabled, you will get an error: HTTP Error 500.0 – Internal Server Error Calling LoadLibraryEx on ISAPI filter "C:\lucee\connector\isapi_redirect-1.2.31.dll" failed.

The other very confusing thing is that if you change the default bit-ness in Application Pool Defaults to 32, IIS overrides individually set AppPool settings and breaks all 64 bit websites. In order to have a mixed 32/64 bit environment you MUST have Application Pool > Enabled 32 bit Application set to FALSE. To allow an individual site to run 32 bit apps, you need to click on the appPool you want to change and click Advanced Settings from the right column. Change the drop down from False (the default) to True

For Plesk to work we need to set both plesk(default)(2.0)(pool) and PleskControlPanel to use 32 bit applications. Once you have done this, browse to your Plesk panel and verify everything is working.

Now that we've got Plesk in a 64 bit environment, we need to add an AppPool for our new website. Click Add Application Pool in the right column and give your pool a meaningful name. The name of the website works well. Leave the other settings as they are.

Now that we've got that set up, we need to associate the new AppPool with the new website. Select the website in the left column and then click Advanced Settings from the right. You'll note that the website is set up by Plesk to use plesk(default)(2.0)(pool). Click on this and then click on the [...] Select your new AppPool and click OK.

## Install Lucee ##

Not much to say here. Run the setup routine, making note of your Tomcat admin password. The installer may request that you choose a port for Tomcat. If you don't get asked, it means that Tomcat can use the default port. If you do, it means that something is using that port. I assume it's Plesk's version of Tomcat.

Once the install is complete and you get the first run page, set your Server & Web Admin Passwords for Lucee.

Now we need to fix one more issue introduced by Plesk. Plesk sets up a jakarta virtual directory pointing to its own version (32 bit) isapi connector for use by its own version of Tomcat. Without going into too much detail about that, the jakarta vDir in any application that uses Lucee needs to be pointed at the Lucee isapi 64bit connector (on a 64 bit OS - which of course ws2008 is). Click on the jakarta subdirectory of your website, Click Advanced Settings in the left column and point the physical path of the Lucee connector.

Now we've cleared up all the issues caused by Plesk and it's time to move on to the final set up of IIS 7.5

### The Home Stretch ###

The Lucee install does a lot of the work for you but we do have to do a few things. The server root node will have a Handler Mapping for *.cfm files set up, but it doesn't seem to set it up for individual sites. Click on your website node and then Handler Mappings. Click Add Script Map from the right column. Set the Request Path to *.cfm. CFC files do not require a mapping.

Point the executable to the {installPath}\connector\isapi_redirect-xx.xx.xx.dll and give it a name.

* note: some of the more eagle eyed of you may notice that the path in the handler mapping screen cap above shows I'm adding the Handler Mapping in the {website} > jakarta section. This was not intentional. You should be in the root node of your website when you add an handler mapping. In this case it should have been luceeinstalltest.ca

Now double check that there is an entry for the isapi connector in the Isapi Filters section. This should be added by the installer but if not you can add it easily.

One final thing to do is to make sure that index.cfm is at the top of the Default Documents list (not necessary but I'd do it in any case). Index.cfm should be added by the installer, but if not you can add it.

### Adding a Tomcat Web context ###

Click on Start Menu >All Programs > Lucee >Tomcat Host Config to open up the Tomcat Server.xml file (a nice touch added by the installer). Scroll to the bottom of this file to add your "web context"; basically tell Tomcat what directory to watch under what website. There is a template to use which is commented out like so

```lucee

<!-- <Host name="[ENTER DOMAIN NAME]" appBase="webapps">
<Context path="" docBase="[ENTER SYSTEM PATH]"" />
</host> -->

```

Copy that and modify it to add the Hostnames of your site and the path to the document root.

Add an alias for each binding of your site that you want to process cfm files. Saves a few lines and if you have a lot of sites, it keeps the file cleaner.

```lucee
<Host name="www.luceeinstalltest.ca" appBase="webapps">
<Context path="" docBase="C:\inetpub\vhosts\luceeinstalltes.ca\httpdocs" />
<Alias>luceeinstalltest.ca</alias>
</host>
```

Save the file and restart Tomcat using Start Menu >All Programs > Lucee > Lucee-Tomcat Service Control

Now at this point we -should- be able to browse our first cfm file. (but I bet you're guessing maybe, just maybe we can't?)

Create a simple cfm Hello World file.

```lucee
<cfoutput>
 <h1>Hello World!</h1>
  <br> The time is #now()#
</cfoutput>
```

and save it to the httpdocs folder of your website and browse to the site and...

You'll note the error detail Cannot read configuration file due to insufficient permissions. Now we know that the website configuration file is web.config and it is located in the document root of each website. So the error message tells us that for some reason, IIS doesn't have permission to read that file, or more accurately, the website's AppPool doesn't. In IIS 7.5 the appPool is an isolated security context for each website, provided you set them up that way as we did. We need to give the appPool permissions to access the directory. Open Explorer and browse to your webroot, in this case inetpub\vhosts and select your website. Right click and select the security tab. Click Edit and then Add. In the Object Names box enter IIS AppPool\{nameof yourAppPool} or in this case IIS AppPool\luceetest. Click ok.

Now at this point (again) you'd think we'd be done, but I discovered that granting permissions at the topmost level of the site doesn't propagate the changes to lower directories like you'd expect. I'm not sure if this is a Server 2008R2 thing or something related to IIS AppPool objects but we need to do one more thing. From the Security Tab of the properties box, click Advanced > Change Permissions. Click in the Permission Entries box and select all of the entries, including the AppPool entry you just added. This step is important and failure to do so can mess up the permissions for the site. Click the Replace All Child Object Permissions With Inheritable Permissions From this Object check box. This will set the permissions of all of the subdirectories of the root website based on the permissions of the root directory (ie: the one we just added the AppPool permission). It does this for each Permission Entry in the list. As such all of the subdirectories will have permissions Read & Execute, List Folder Contents and Read set for your website AppPool.

Finally, back to the browser and...
