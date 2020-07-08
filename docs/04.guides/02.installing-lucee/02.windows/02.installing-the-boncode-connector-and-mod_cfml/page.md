---
title: Installing the Boncode connector and mod_cfml
id: running-lucee-installing-the-boncode-connector-and-mod_cfml
---

At the time of this writing : mod_cfml is at v1.1.05, Boncode AJP connector is at v1.0.32, Tomcat is at v8.5.6

**Please note : These instructions were written for Windows Server 2016 (64 bit)**

## Download & Install mod_cfml Tomcat Valve

[[mod-cfml]] dynamically creates hosts in Tomcat based on the request headers of the incoming request.

* [Download the latest mod_cfml](https://viviotech.github.io/mod_cfml/download.html)
* [Install mod_cfml to Apache on Windows](https://viviotech.github.io/mod_cfml/install-win-apache.html)
* [Install mod_cfml to Apache on Ubuntu](https://viviotech.github.io/mod_cfml/install-lin-ubuntu.html)
* [Install mod_cfml to IIS on Windows](https://viviotech.github.io/mod_cfml/install-win-iis.html)
* [Install mod_cfml to NGINX (any OS)](https://viviotech.github.io/mod_cfml/install-nginx.html)

## Download & Install Boncode AJP 1.3 Connector

BonCode AJP (Apache JServ Protocol version 1.3) Connector is used connect the IIS web server to the Apache Tomcat server.  Apache already supports AJP out of the box.

### Boncode AJP 1.3 Connector Prerequisites ###

ASP dot NET Framework version 3.51 or higher must be installed

## Automatic Install of Boncode AJP connector with default settings ##

For the purposes of simplicity, do an automatic install of the Boncode AJP 1.3 connector with the default settings.

* [Download the Boncode AJP connector](http://www.boncode.net/boncode-connector)
* Extract the .zip file into a temporary directory
* Launch Connector_Setup.exe
* Accept defaults for each installation option

### Edit BonCodeAJP13.settings file ###

On windows 2016 with a default install of Boncode, the location of BonCodeAJP13.settings file is "C:\Windows\BonCodeAJP13.settings".

Previous versions of Windows may place this file in "C:\Windows\System32\BonCodeAJP13.settings"

* Launch your favorite text editor **as a local Administrator** and open BonCodeAJP13.settings
* Add the following items just before the closing `</Settings>` tag

```
<EnableHeaderDataSupport>True</EnableHeaderDataSupport>
<ModCFMLSecret>secret key also set in the Apache/IIS config</ModCFMLSecret>
```

* Replace the secret key value ('secret key also set in the Apache/IIS config') with a random secure key.  If you need help creating one, you can generate a reasonably secure unique key here https://www.grc.com/passwords.htm
* Save the BonCodeAJP13.settings file **(Note: If you did not open your text editor as an Administrator, you may not be able to overwrite the existing file due to NTFS permissions)**

### Edit Tomcat server.xml file ###

If you followed the instructions on the previous pages, the Tomcat server.xml file should be in "D:\Tomcat\conf\server.xml"

On a default Tomcat install, the Tomcat server.xml file should be in "C:\Program Files\Tomcat\conf\server.xml" and you may need to edit the file

* Launch your favorite text editor **as a local Administrator** and open the Tomcat server.xml file.
* Locate the Host section near the end of the configuration which reads `<Host name="localhost"...`
* Add the following code block before the closing `</Host>` tag.

```
    <Valve className="mod_cfml.core"
		   loggingEnabled="false"
		   maxContexts="100"
		   timeBetweenContexts="0"
		   scanClassPaths="false"
		   sharedKey="secret key also set in the Apache/IIS config" />
```

* Replace the secret key value ('secret key also set in the Apache/IIS config') with the same key you used in the BonCodeAJP13.settings file above.
* Restart the Tomcat service

### Optional - relocating WEB-INF files outside the web root ###

[[relocating-web-inf]]

** To-do's **

* How to perform manual installation of Boncode
* Document the settings for Boncode's automatic installer

If you need help try asking the helpful folks in the [#lucee Slack channel](http://cfml-slack.herokuapp.com) or have a search of [Lucee mailing list](https://dev.lucee.org) archives
