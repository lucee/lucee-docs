---
title: Utilizing Tomcat's Built-In Web Server
id: windows-utilizing-tomcat-built-in-web-server
---

In some situations, it may be advantageous to remove Windows IIS and simply use Tomcat's built-in web server as the web server. This can eliminate bottle-necks for dynamic content and removes the need for double-configurations in each application.

### Updating the server.xml File ###

On Windows, running Tomcat on port 80 (the standard web server port), is as simple as modifying the tomcat server.xml file. By default, the file is located at:

	c:\lucee\tomcat\conf\server.xml

Once you've found the file, update this section:

	<Connector port="8888" protocol="HTTP/1.1" connectionTimeout="20000" redirectPort="8443" />

to this:

	<Connector port="80" protocol="HTTP/1.1" connectionTimeout="20000" redirectPort="443" />

### Restart Tomcat ###

You can restart Tomcat a number of ways, but the most familiar way is probably through the services applet:

### Check the Port ###

Next check to make sure Tomcat is listening on port 80. You can check with a browser and just open "localhost", but if you want to be absolutely sure, you can open a powershell and run the following command:

	 netstat -abn -p tcp

and you should see that it's tomcat that's listening to TCP port 80