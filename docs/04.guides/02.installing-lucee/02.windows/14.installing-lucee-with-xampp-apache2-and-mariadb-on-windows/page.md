---
title: Installing Lucee And XAMPP (Apache2 & MariaDB) on Windows
id: running-lucee-installing-xampp-apache2-and-mariadb-on-windows
---

## Installing Lucee And XAMPP (Apache2 & MariaDB) on Windows ##

This documentation shows how to install and configure Lucee Server With XAMPP's Apache2 webserver on a Windows machine, making all benefits of develolping with XAMPP available to Lucee cfml developers.
<br>
<br>

### 1. Introduction ###

Citing the projects webpage, "XAMPP is a completely free, easy to install Apache distribution containing MariaDB, PHP, and Perl. The XAMPP open source package has been set up to be incredibly easy to install and to use."

While XAMPP is not meant for production deployments, it can be perfectly used to easily & quickly install a complete/full local development environment for web applications. That can later be deployed easier on CFML hosting environments or LAMP servers that host Lucee cfml engine.

### 2. Benefits of using XAMPP with Lucee ###

XAMPPs main benefit is, that it may help developing typical CFML web applications in parallel with PHP driven applications using the same local development environment with MariaDB. If you are a PHP web application developer using frameworks such as WordPress, Typo3, flat file content management systems like Kirby or others, you can use the very same XAMPP environment
to develop Lucee driven CFML web applications. You may also use the same tools such as phpMyAdmin to administer your local MariaDB. 

### 3. Step By Step Instruction Guide ###

This step by step guide shows a basic installation of XAMPP on Windows and Lucee with the "Lucee Windows Installer" that also ships Tomcat coming with a pre-bundled Java Runtime Environment. We are **NOT(!!!)** installing Tomcat from XAMPP, but from the Lucee installer. The reason is that it already comes preconfigured to run Lucee with all its necessary libraries. Of course, you may use XAMPPs Tomcat if wished, but then you'd also need to do all manual configuration and setup to run Lucee JVM servlet container in XAMPPs Tomcat.  

- Step 1: Make sure you don't have IIS feature installed or IIS running on your Windows, because it will interfere with your Apache2 webserver installation. Also, Lucee installer will try to detect the webserver automatically, so make sure you have no webserver installed and running before the following steps. 
- Step 2: Download XAMPP for Windows at [Apachefriends.org Downloads](https://www.apachefriends.org/de/download.html)
- Step 3: Right-click the XAMPP installer file and run it as administrator 
- Step 4: Select to install everything you need but NOT Tomcat(!!!): Tomcat will come from the Lucee Installer
- Step 5: Open the **XAMPP Control Panel** and start Apache2 webserver. Then check if the Apache2 is running fine by navigating to `http://localhost`. You should see the *"XAMPP Welcome Page"*
- Step 6: Download "Lucee Installer For Windows" at [Lucee's Downloads](https://download.lucee.org/)
- Step 7: Right-click the downloaded *"Lucee Installer For Windows"* file and run it as administrator 
- Step 8: Accept the terms of services and click *"next"*
- Step 9: Define the installation directory, e.g. `C:\lucee` and click *"next"*
- Step 10: If the installer asks you to use the existing Java installation, make sure to *"Install the bundled JRE"* and click *"next"*. The reason is that you may have a Java version installed on your OS that isn't supported by Lucee. Installing the bundled JRE ensures you'll be running a dedicated preshipped JRE for your Lucee and Tomcat. 
- Step 11: Define the password for your *"Lucee Administrator"* and click *"next"*
- Step 12: Define the memory you want to give your Java Virtual Machine for Lucee and click *"next"*
- Step 13: Keep the default for Tomcat ports (AJP: *8009*, Shutdown: *8005*, Http: *8888*) and click *"next"*
- Step 14: Make sure to keep *"Yes, Start Lucee at Boot Time"*. This will install Tomcat/Lucee as a service on your Windows
- Step 15: Make sure to untick *"Install the IIS connector"*, because you won't be using IIS, but Apache2 webserver that came with XAMPP
- Step 16: When being asked to open the *"Lucee Welcome"* page, just click *"finish"* and you will be directed to the Lucee Welcome Page. Until here you've installed Apache2 and Lucee with Tomcat, but these still haven't been connected. To connect them follow the next steps:
- Step 17: Open the ajp config file at `C:\xampp\apache\conf\extra\httpd-ajp.conf` and add the following lines to the bottom:

```
ProxyPreserveHost On
ProxyPassMatch ^/(.+\.cf[cm])(/.*)?$ ajp://127.0.0.1:8009/$1$2
ProxyPassMatch ^/(.+\.cfml)(/.*)?$ ajp://127.0.0.1:8009/$1$2
# optional mappings
#ProxyPassMatch ^/flex2gateway/(.*)$ ajp://127.0.0.1:8009/flex2gateway/$1
#ProxyPassMatch ^/messagebroker/(.*)$ ajp://127.0.0.1:8009/messagebroker/$1
#ProxyPassMatch ^/flashservices/gateway(.*)$ ajp://127.0.0.1:8009/flashservices/gateway$1
#ProxyPassMatch ^/openamf/gateway/(.*)$ ajp://127.0.0.1:8009/openamf/gateway/$1
#ProxyPassMatch ^/rest/(.*)$ ajp://127.0.0.1:8009/rest/$1
ProxyPassReverse / ajp://127.0.0.1:8009/
```

- Step 18: Make sure to set as comment any additional proxyPass directives that may conflict with the cfml proxyPass above.
- Step 19: Try opening `http://localhost`. You will see a Tomcat `403 Forbidden` Page. That means Apache2 webserver is connected correctly to AJP, but AJP isn't configured with the proper permission in Tomcat. The cause is that Tomcat comes with a "secretRequired" attribute by default.
- Step 20: Make sure that your XAMPP comes with an Apache2 server that already supports secret for AJP. According to their docs that is from 2.4.42 and later (see [mod_proxy_ajp.html documentation](https://httpd.apache.org/docs/2.4/mod/mod_proxy_ajp.html))
You can find you installed Apache2 Version by reading `C:\xampp\readme_en.txt`. By time of writing of this setup guide, the Apache2 version bundled with XAMPP is Apache 2.4.53, so we will configure the secret in the following steps.
- Step 21: Open the apache AJP config file at `C:\xampp\apache\conf\extra\httpd-ajp.conf` and add the secret (we will use the string `MySecretPassword` in this example) to your active proxyPass directive like so:

```
ProxyPreserveHost On
ProxyPassMatch ^/(.+\.cf[cm])(/.*)?$ ajp://127.0.0.1:8009/$1$2 secret=MySecretPassword
ProxyPassMatch ^/(.+\.cfml)(/.*)?$ ajp://127.0.0.1:8009/$1$2 secret=MySecretPassword
# optional mappings
#ProxyPassMatch ^/flex2gateway/(.*)$ ajp://127.0.0.1:8009/flex2gateway/$1
#ProxyPassMatch ^/messagebroker/(.*)$ ajp://127.0.0.1:8009/messagebroker/$1
#ProxyPassMatch ^/flashservices/gateway(.*)$ ajp://127.0.0.1:8009/flashservices/gateway$1
#ProxyPassMatch ^/openamf/gateway/(.*)$ ajp://127.0.0.1:8009/openamf/gateway/$1
#ProxyPassMatch ^/rest/(.*)$ ajp://127.0.0.1:8009/rest/$1
ProxyPassReverse / ajp://127.0.0.1:8009/ secret=MySecretPassword
```

- Step 22: Open the Tomcat configuration file at C:\lucee\tomcat\conf\server.xml and search for the string `8009` in that file. You'll be directed to the AJP connectors directive tag for port 8009 and change it like so:

```
<!-- Define an AJP 1.3 Connector on port 8009 -->
    <Connector protocol="AJP/1.3"
	    port="8009"
	    secret="MySecretPassword"
	    secretRequired="true"
               redirectPort="8443" />
```

- Step 23: Restart Tomcat/Lucee in your Windows services and wait Tomcat to start and create all the web contexts
- Step 24: Restart Apache2 from within your **XAMPP Control Panel**
- Step 25: Try opening `http://localhost` and you'll see the cfm page being delivered, but the static files will fail to load making the page look ugly without images and css. That's because you need to adapt your configuration in such a manner, that your `wwwroot` works in Apache2 but also in Tomcat
- Step 26: Open to edit `C:\xampp\apache\conf\httpd.conf` and search for the string `DocumentRoot`.
- Step 27: Change the document root directive from `C:/xampp/htdocs` and your directory directive to Lucees default localhost directory like so:

``` 
DocumentRoot "C:\lucee\tomcat\webapps\ROOT"
<Directory "C:\lucee\tomcat\webapps\ROOT"> 
``` 

- Step 28: Restart Apache2 from within your XAMP control panel
- Step 29: Open `http://localhost/index.cfm` and you should see the Lucee welcome page reendered with all static files.

For installing mod_cfml for Tomcat automatic host configuration, please following the mod_cfml instructions at [Viviotech mod_cfml windows apache installation](https://viviotech.github.io/mod_cfml/install-win-apache.html)
