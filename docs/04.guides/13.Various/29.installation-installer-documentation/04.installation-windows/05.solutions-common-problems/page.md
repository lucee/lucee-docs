---
title: Solutions to Common Problems
id: windows-solutions-to-common-problems
---

### Welcome Page instead of Web Site ###

If you get the Lucee Welcome page instead of the web site that you're trying to reach, there are several possible causes. It is recommended that you troubleshoot this problem by taking the following steps:

1. It is possible that mod_cfml just needs a few seconds to create the new host in Tomcat. Try waiting a couple seconds and hit the URL again.
1. Clear your browser's cache to make sure that your browser isn't caching the page.
1. It's possible the host was created improperly. Restart both your web server (IIS and Apache) and Tomcat/Lucee and see if the host is created properly after the restart.
1. It's possible that mod_cfml doesn't have something it needs to create the new host. Try adding the host manually to Tomcat's server.xml file (Documentation)
1. If the host continues to not resolve, check the server.xml file for CaSe SeNsiTivIty issues. The XML used in the Tomcat server.xml file is case-sensitive, so if something isn't working even if you add it manually, it might be due to case-sensitivity.

If you continue to have trouble, we encourage you to tell us about it on the Lucee Open Source Community Mailing List.

### Lucee-Tomcat Service" Access Denied Error ###

When you attempt to run the Tomcat Service Controls you get a "Permission Denied" message. This occurs because the Tomcat Service Controls need administrative rights in order to function properly. There are several ways in which you can address this problem:

* Add your User Account to the Administrators group (recommended)
* Right-click the link and select "Run as Administrator"
* Log in as the Administrator user in order to manage Lucee/Tomcat
* IIS7+ Enable Anonymous Authentication and edit the setting so that Anonymous user identity: is using "Application Pool identity"

### IIS7 Error: LoadLibraryEx on ISAPI filter ###

**NOTE:** This solution is only relevant for Lucee 3.3.2 and BELOW, and is not relevant in newer releases of the Lucee Installer.

### The Cause ###

This particular error is caused by the Tomcat connector being the wrong bit type for the IIS Application pool. Either you've installed a 64-bit connector on a 32-bit IIS Application Pool, or you've installed a 32-bit connector on a 64-bit IIS Application Pool.

### The Fix ###

The fix for this is simply to replace the connector that's been installed with a connector of the right bit type - both of which are packaged along with the Lucee installer files as of version 3.1.2.001-pl1-alpha1. Look in your c:\lucee\connector\ directory and you should see both connector DLL files. The connector that has a bit type specified in the name is the connector that is NOT in use at the moment.

* Note on IIS 7.5

	* It's important here to have a clear understanding as to what Enable 32 Bit Applications means. For IIS 7.5, Enable means Only Allow 32 Bit Applications. If you change the default bit type in Application Pool Defaults to 32, IIS will create all new AppPools with 32 bit enabled preventing 64 bit apps from running. Additionally, IIS overrides individually set Application Pool settings and breaks all 64 bit websites. In order to have a mixed 32/64 bit environment you MUST have Application Pool > Enabled 32 bit Application set to FALSE. To allow an individual site to run 32 bit apps, you need to click on the Application Pool you want to change and click Advanced Settings from the right column to change it.

* **/jakarta/isapi_redirect.dll file not found**

**NOTE:** This solution is only relevant for Lucee 3.3.2 and BELOW, and is not relevant in newer releases of the Lucee Installer.

This error usually means that your IIS site doesn't have the "jakarta" directory in it. The "jakarta" virtual directory is the path that the connector uses to send requests off to Tomcat for processing, so it is required for every site that needs CFML processing functionality.
