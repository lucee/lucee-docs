---
title: Configuring SES URL's
id: lucee-configuring-SES-url
---

### mod_proxy/mod_rewrite SES URL's ###

The following is an example of a FW1 config that does NOT display the index.cfm in the URL:

	RewriteEngine On
	#Rewrite index.cfm
	RewriteCond %{REQUEST_FILENAME} !-f
	RewriteCond %{REQUEST_FILENAME} !-d
	RewriteCond %{REQUEST_URI} !^.*\.(bmp|css|gif|htc|html?|ico|jpe?g|js|pdf|png|swf|txt|xml)$
	RewriteRule ^(.*)$ http://127.0.0.1:8888/index.cfm/$1 [NS,P]
	ProxyPassReverse / http://127.0.0.1:8888/

In essence, if Apache gets a request for a URI that is NOT a file, and NOT a directory, it is to rewrite the request and put an index.cfm in the URI. That request is then passed off to the standard mod_proxy config which is set to handle all ".cfm" requests.

### mod_jk SES URL's ###

**NOTE: This information is only relevant for Lucee 3 and BELOW. Newer releases of the Lucee 4 Installer come with mod_proxy installed by default instead of mod_jk.**

Search Engine Safe (SES) URL's are very cool for getting all of your site indexed in a meaningful way by a lot of search engines.It's also a handy way of linking to various aspects of your site in a way that looks good.

Using the Lucee Installer along with SES URL's is a relatively simple process, once you understand how each processes involved works. Essentially, when working with SES URL's you have to remember that when a request first comes in, it hits Apache. If things are set up right, it will hit Apache, get passed to Tomcat, and subsequently get passed to Lucee. You just need to make sure both Apache and Tomcat understand WHICH URL's to pass on to Lucee in order for SES URL's to work.

### Modify Apache Config ###

You can control what URL patters are passed off to Tomcat by updating the main Apache Config file. This is usually httpd.conf in RedHat-based systems (like CentOS) or apache2.conf in Debian-based systems (like Ubuntu). Further, you'll need a part of the URL to "Key" off of. This "key" will tell Apache that this is a URL that needs to be passed off. CMS systems, such as [Mura](http://getmura.com/), give you the ability to specify a "site" for your SES URL. This site name makes a perfect "key".

So, with this in mind, if your SES URL is suppose to look like this:

	https://lucee.org/site/contact/business/

Then your Apache config file might look something like this:

	<IfModule mod_jk.c>
		JkMount /*.cfm ajp13
		JkMount /*.cfc ajp13
		JkMount /*.do ajp13
		JkMount /*.jsp ajp13
		JkMount /*.cfchart ajp13
		JkMount /*.cfm/* ajp13
		JkMount /*.cfml/* ajp13

		# ADD MY SES SITE KEY
		JkMount /site/* ajp13

		# Flex Gateway Mappings
		# JkMount /flex2gateway/* ajp13
		# JkMount /flashservices/gateway/* ajp13
		# JkMount /messagebroker/* ajp13
		JkMountCopy all
		JkLogFile [log directory]/mod_jk.log
	</ifmodule>

Note that in the above example, we're passing every request that comes in under the "site" key off to Tomcat. You'll probably still want Apache to handle the simple stuff like serving images and so forth, as it saves threads being started unnecessarily by Tomcat.

If you do not wish to use a site "Key", that's okay, but you will need to send EVERY request off to Tomcat. This means you will not be able to do things like process PHP pages, etc, from this server. You will need to choose how important having a site "Key" is compared to how important it is to processing PHP on the same server. Apache will serve little to no purpose in this scenario, as every request it gets will be passed to Tomcat.

There is a way around this, with a site-specific mod_jk configuration, but I'm not going to go into the complex details of that unless there is an interest. Please post a request on the Lucee mailing list if you're interested in knowing how to do this.

### Tomcat web.xml Config ###

For Tomcat, we will need to create a web.xml file that is site-specific, that way you can create mappings that only apply to a single site and not every site that's hosted by Tomcat. To do this, you will need to create the web.xml file within the WEB-INF file that lucee creates for a new site. The process goes something like this:

1. The first step is to modify the server.xml file with the information for the new site Explained Here

1. Restart Tomcat so that the WEB-INF directory is created in the "DocBase" path, or create the directory yourself

1. Once the WEB-INF directory is created, create the web.xml file inside it. IE: /home/user/mysite.com/WEB-INF/web.xml

1. Once you've created the file, add something similar to the following to create the site-specific mappings:

**For Mura**

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
You can add and remove additional <url-pattern></url-pattern> attributes as needed by your specific application.

Once you've added the web.xml files to the site, you may need to restart Tomcat for the updated configs to take full effect.

