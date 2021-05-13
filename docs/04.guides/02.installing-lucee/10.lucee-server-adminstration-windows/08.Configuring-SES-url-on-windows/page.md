---
title: Configuring SES URL's on Windows OS's
id: windows-configuring-SES-url-on-windows-os
---

**NOTE:** This information is only relevant for Lucee 3.3.2 and BELOW. Newer releases of the Lucee Installer come with the improved BonCode Connector which does not require a workermap.

The following describes how to configure Search Engine Safe (SES) URL's working on Windows systems and the installer. I would say 95% of the problems that are encountered with setting up SES URL's have to do with a service not knowing where to hand off the request.

When a request comes in on a Windows System, it hits IIS, which looks at the uriworkermap.properties file and (theoretically) gets passed to Tomcat. From there, Tomcat checks it's web.xml file, and (theoretically) the request gets passed to the Lucee servlet, from there, the CFML is read from the file system and the request is processed accordingly.

### Configuring IIS ###

IIS configuration is governed by the uriworkermap.properties file. The IIS connector knows what to hand off to Tomcat based on the URL patterns that are laid out in this file.

So, with that in mind: **If you're setting up SES URL's and you're getting a 404 from IIS, chances are very good that you need to check your uriworkermap.properties file and make sure the URL you're trying to hit is being passed off to Tomcat**.

Updating the uriworkermap.properties file is talked about in detail here
.
[[windows-updating-uriworkermap-properties-file]]

The general idea, though, is to identify a pattern that will always be used in the URL that needs to get passed off to Tomcat (Identify the "key"). So, if your SES URL looks something like this:

	http://www.mysite.com/mysite/content/newcontent/

Then the "Key" would be the "/mysite/" in the URL. That means that you could edit your uriworkermap.properties file and add the following line:

	 /mysite/*=ajp13

If your site doesn't have something in the URL to key off of, then you're going to have to pass EVERYTHING off to Tomcat and Lucee. This is not very efficient, as threads by the processing engine will be wasted on mundane tasks, but it will get the job done. Something like this will work in your uriworkermap.properties file:

	/*=ajp13

However, at this point IIS will be pretty useless. The only thing it will be doing is handing off requests to Tomcat. You may want to consider removing IIS and just [[utilizing-tomcat-built-in-web-server]].

### Configuring Tomcat ###

Now that Tomcat is getting the request passed to it from IIS, we now have to tell Tomcat how to handle it. In general, this just means that we want to tell Tomcat to pass the request off to Lucee.

There are actually several different ways to configure Tomcat, but we recommend what's generally referred to as the "Site Specific web.xml" method, as it gives you greater control and flexibility over how Tomcat handles requests that are sent to it. To do this, you will need to create the web.xml file within the WEB-INF file that lucee creates for a new site. The process goes something like this:

1. The first step is to modify the server.xml file with the information for the new site explained here [[windows-updating-tomcat-server-xml-file]].
1. Restart Tomcat so that the WEB-INF directory is created in the "DocBase" path, or create the directory yourself
1. Once the WEB-INF directory is created, create the web.xml file inside it. IE: C:\websites\mysite.com\WEB-INF\web.xml
1. Once you've created the file, add something similar to the following to create the site-specific mappings:

### For Mango Blog ###

```lucee
<?xml version="1.0" encoding="ISO-8859-1"?>
<web-app xmlns="http://java.sun.com/xml/ns/javaee"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
    version="2.5">
    <servlet-mapping>
	   <servlet-name>CFMLServlet</servlet-name>
	   <url-pattern>/blog/post.cfm/*</url-pattern>
	   <url-pattern>/blog/page.cfm/*</url-pattern>
	   <url-pattern>/blog/archives.cfm/*</url-pattern>
	   <url-pattern>/blog/feeds/rss.cfm/*</url-pattern>
	</servlet-mapping>
</web-app>
```

### For Mura ###

```lucee
<?xml version="1.0" encoding="ISO-8859-1"?>
 <web-app xmlns="http://java.sun.com/xml/ns/javaee"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
    version="2.5">
       <servlet-mapping>
       <servlet-name>CFMLServlet</servlet-name>
       <url-pattern>/index.cfm/*</url-pattern>
       <url-pattern>/default/index.cfm/*</url-pattern>
    </servlet-mapping>
</web-app>
```

You can add and remove additional <url-pattern></url-pattern> attributes as needed by your specific application.

Once you've added the web.xml files to the site, you may need to restart Tomcat for the updated configs to take full effect.
