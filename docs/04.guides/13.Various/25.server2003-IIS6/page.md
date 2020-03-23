---
title: Server 2003 and IIS6
id: server-2003-IIS
---

### Windows 2003 and IIS 6 ###

Here's a guideline on how to install Lucee on Win2K3 with IIS6.

* Select Windows version of the Lucee Server and download it from [https://lucee.org/downloads.html](https://lucee.org/downloads.html)

* Unizp or execute the file (depending if you selected .zip or .exe) and install it to c:\Lucee

* Check if Lucee runs correctly by calling http://localhost:8600/index.cfm you should see the following:

* If Lucee runs correctly IIS has to be configured. Go to Step 4.

* If Lucee does not start, or you don't see the above screen, please try the following:

* Check whether the service Lucee 2.0 runs

* If the service runs, please check whether the firewall is blocking the server to run

* If the service does not run, please execute the following command in the {lucee installation directory}


C:\Lucee>httpd.exe -Xms512M -Xmx512M -conf conf/resin.conf -java_home jre -java_exe jre\bin\java
Then the reason for Lucee failing to start should be displayed

* If Lucee still does not run function properly, it is time to write an email in the Lucee User Group

* IIS and Resin need to mirror their configuration. So every host entry in the IIS (website) needs to reflect in the resin.conf found in the directory C:\Program Files\Lucee\conf You might need to enter following lines inside the <cluster></cluster> tag of the file:

```lucee
<host id="&lt;span style=&quot;color:#0000CC&quot;&gt;&quot;myweb.com&quot;&lt;/span&gt;">&lt;/span&gt;</host> <root-directory>&lt;/span&gt;d:/webroots/myweb.com<span style="color:#000099">&lt;/root-directory&gt;</span> <span style="color:#000099">&lt;web&#45;app id=&quot;&amp;lt;span style=&amp;quot;color:#0000CC&amp;quot;&amp;gt;&amp;quot;/&amp;quot;&amp;lt;/span&amp;gt;&quot; document&#45;directory=&quot;&amp;lt;span style=&amp;quot;color:#0000CC&amp;quot;&amp;gt;&amp;quot;d:/webroots/myweb.com&amp;quot;&amp;lt;/span&amp;gt;&quot;&gt;&lt;/web&#45;app&gt;</span> <span style="color:#000099">&lt;/host&gt;</span><br>&lt;/span&gt;&lt;/div&gt;</root-directory>
or to make it much more comfortable:

<host regexp="&lt;span style=&quot;color:#0000CC&quot;&gt;&quot;(.+)&quot;&lt;/span&gt;">&lt;/span&gt;</host>
<host-name>&lt;/span&gt;</host-name>${host.regexp[1]}</host-name>
<root-directory>&lt;/span&gt;d:/webroots/$<span style="color:#000099">{</span>host.regexp[1]<span style="color:#000099">}</span><span style="color:#000099">&lt;/root-directory&gt;</span><br><span style="color:#000099">&lt;web&#45;app id=&quot;&amp;lt;span style=&amp;quot;color:#0000CC&amp;quot;&amp;gt;&amp;quot;/&amp;quot;&amp;lt;/span&amp;gt;&quot; document&#45;directory=&quot;&amp;lt;span style=&amp;quot;color:#0000CC&amp;quot;&amp;gt;&amp;quot;d:/webroots/$&amp;lt;span style=&amp;quot;color:#000099&amp;quot;&amp;gt;&#123;&amp;lt;/span&amp;gt;host.regexp&#91;1&#93;&amp;lt;span style=&amp;quot;color:#000099&amp;quot;&amp;gt;&#125;&amp;lt;/span&amp;gt;&amp;quot;&amp;lt;/span&amp;gt;&quot;&gt;&lt;/web&#45;app&gt;</span><br><span style="color:#000099">&lt;/host&gt;</span><br>&lt;/span&gt;&lt;/div&gt;<br> In the second case resin determines with the help of a regular expression where to locate a certain webroot. So you only need to create a directory named d:\webroots\hostname and the setting is valid without having to restart the application server service. But I wouldn't recommend this kind of definition, because it can grant access to webroots without manually allowing it.<br><br>&lt;/cluster&gt;&lt;/li&gt;</root-directory>
```

* Set up a new website according to your needs by using the according wizard.

* If not already existent, create a folder named scripts inside a common directory (eg. D:\webroots\).

* Copy the file C:\Program Files\Lucee\Wind32\isapi_srun.dll into the created directory

* Inside the IIS management console navigate to the Web Service Extensions

* Click on Add new Web service extension

* Add the dll as a named extension and set it's status to Allowed
Now your dll is an allowed extension you can use within the web site.

* If you want to use Lucee globally with every website you create, right click on websites and follow the instructions below.

* Click on "Web Sites" Properties

* Click on Home Directory/Configuration

* Add two Application Extension Mappings for .cfm and .cfc pointing to D:\webroots\scripts\isapi_srun.dll Please uncheck the Verify that file exists checkbox.

* If you only want a certain webhost to act on .cfm and .cfc files with Lucee, you need to execute the above actions for the respective Website.

* Save the configuration of the IIS to disk, by selection All tasks/Save Configuration to disk in the context menu of the IIS server

* restart the IIS service All tasks/Restart IIS... Now the website should run with Lucee.

* If you experience any issues with Lucee, please follow the instructions on the following documentation page: [http://www.caucho.com/resin-3.1/doc/install-iis.xtp](http://www.caucho.com/resin-3.1/doc/install-iis.xtp)