---
title: Newbie Questions
id: getting-started-newbie-questions
---

## **Setting up multiple Lucee websites on Windows/IIS:** ##

These instructions assume you know how to set up DNS, port forwarding for your router, and how to add a new site in IIS.

1) Install Lucee (I installed http://railo.viviotech.net/downloader.cfm/id/134/file/lucee-4.5.1.000-pl0-windows-installer.exe from http://lucee.org/downloads.html )

2) Verify that Lucee is running (The internal IP of my Lucee server is 192.168.1.80, so I went to http://192.168.1.80:8888 to view the Hello Lucee page, which verified a successful deployment)

3) Set up DNS for a site, if you haven't already (I added lctest.blahblah.com to my GoDaddy DNS). Set up port forwarding on your router, if needed. Add your new site to IIS.

4) Create your local folder, if you haven't already ( I used C:\sites\lctest)

5) Add a Host entry to Server.XML - I installed to the default location (C:\lucee) so the path is C:\lucee\tomcat\conf\server.xml)

6) Just above the </Engine> tag, add the following Host entry:

	<Host name="lctest.blahblah.com" appBase="webapps"
		 unpackWARs="true" autoDeploy="true"
		 xmlValidation="false" xmlNamespaceAware="false">
		 <Context path="" docBase="C:\sites\lctest\" />
		<Alias>lctest.blahblah.com</Alias>
	</Host>

Substitute your host name and alias, and put in your local folder for docBase

7) Save the XML file and Restart Lucy - in Windows 2012 R2, click the Start button, click the down arrow, select Lucy-Tomcat Service Control

8) On the General tab, click the Stop button. When Service Status changes to Stopped, click the Start button.

9) Create a simple index.cfm file - if you're stumped, you can use the example code from Tom Kitta's tutorial - http://www.tomkitta.com/guides/cf_101.cfm

10) Navigate to your alias - for me, it was http://]lctest.blahblah.com - and check that index.cfm executes

The same principles apply for migrating existing sites to a new Lucee server, after setting up any necessary datasources and, if needed, SMTP server.



## **Enabling Debugging on multiple Lucee websites** ##


Create a web.config file in the site's root folder. It should contain:

<configuration>
   <system.webServer>
      <httpErrors errorMode="Detailed" />
   </system.webServer>
</configuration>

Here is a quick way to get a dump to make sure debug works (add to your index.cfm file):

<cfdump var="#{ URL: URL, variables: variables, CGI: CGI }#">
