---
title: Securing /WEB-INF/ by moving it outside of the web root
id: relocating-web-inf
categories:
- server
description: By default, Lucee places its web-context configuration and data files in a folder named WEB-INF within the web root of each website.
menuTitle: Securing /WEB-INF/
---

### Securing /WEB-INF/ by moving it outside of the web root ###

By default, Lucee places its web-context configuration and data files in a folder named WEB-INF within the web root of each website.
The WEB-INF folder structure gets created automatically when Lucee gets called to serve up a .cfm/.cfml file.
If you wish to redirect the web-context data elsewhere, follow the instructions below.

This is for Windows
If you followed the instructions on previous pages, you already have a folder called D:\Lucee\.  

Create a subfolder called "web-contexts" within D:\Lucee\

* Launch your favorite text editor **as a local Administrator** and open `D:\Tomcat\conf\web.xml`
* Locate the section near the end of the configuration which reads `<servlet-name>CFMLServlet</servlet-name>`
* Locate the `<init-param>` section which contains `<param-name>lucee-web-directory</param-name>`
* Replace the `<param-value>` with `D:\Lucee\web-contexts\{web-context-label}`
* Restart the Tomcat service

**For Linux** 

Create a subfolder in `/var/www/` called "web-contexts"
`mkdir /var/www/web-contexts`

Edit the web.xml file with your favorite command line editor, such as vi, vim, pico

`vi+310 /opt/lucee/tomcat/conf/web.xml`

around line 310
Comment out or replace the following line:
`<!--  <param-value>/var/Lucee/config/web/{web-context-label}/</param-value> -->`
With this line:
      `<param-value>/var/www/web-contexts/{web-context-label}/</param-value>`

Make sure to remove the <!-- and
-->  below the newly added line.

Your new init-param should look like this:
<init-param>
     <param-name>lucee-web-directory</param-name>
     <!--  <param-value>/var/Lucee/config/web/{web-context-label}/</param-value> -->
     <param-value>/var/www/web-contexts/{web-context-label}/</param-value>
     <description>Lucee Web Directory (for Website-specific configurations, settings, and libraries)</description>
  </init-param>


Change the ownership of the new web-contexts to the same user and group that your lucee process belongs to.
Restart your lucee instance

