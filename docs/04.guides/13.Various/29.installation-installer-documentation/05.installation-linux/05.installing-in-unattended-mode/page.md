---
title: Installing in Unattended Mode
id: linux-installing-in-unattended-mode
---

In some situations, it may be usful to launch the installer via a script or maybe you just want to install Lucee silently without being prompted at all or using any kind of GUI interface. Thankfully, unattended mode installations are a built-in feature of the Lucee Installers, and it's easy to use. The following instructions will talk about how to launch the installers in unattended mode and what variables can be customized via command-line inputs.

### Launch the Installer in Unattended Mode ###

To launch the installer in unattended mode, you will need to run the following from the command-line:

	# lucee-[version]-installer.run --mode unattended

After unattended mode has been initialized, default values will be used in required locations with the exception of where there are no default values. If there is no default value on a variable where a value is required.

The following is required and does not have a default. This value MUST be specified or the installer will fail with an error saying this variable doesn't have a value.

**--luceepass**

**Default Value:** [None]

The password that will be used for the Lucee Administrators at install time. **This password must be 6 characters or more.**

	# lucee-[version]-installer.run --mode unattended --luceepass "this is my password"

Simply running the above will make the installer use default values, including the default ports, installing the Apache connector if Apache is present, and use default usernames and installation directories. The default values for these variables is defined in detail below

### Installer Variables ###

The following variables can also be customized by passing them to the installer via the command-line.

**--tomcatport**  
**Default Value:** [8888]  
The port number Tomcat will use for it's internal web server (coyote). This port is what's used by default for Apache mod_proxy_html.  

**--tomcatshutdownport**  
**Default Value:** [8005]  
The Tomcat shutdown port number. This port should not be open to the Internet.

**--tomcatajpport**  
**Default Value:** [8009]  
This is the port the AJP listener will be connecting to. This port is used by mod_jk and mod_proxy_ajp and is requried to be available to your apache server if you are using either of those connection methods.

**--systemuser**  
**Default Value:** [root]  
This is the user account that Lucee will run as on your system. If this user account doesn't exist at Install time, a user and group account will be made using this name and Lucee will run as this system user.

**--startatboot**  
**Default Value:** [true]  
This is a BOOLEAN value, meaning it must be true or false.
The default setting of "true" will copy the lucee_ctl script to the /etc/init.d/ directory and use system commands to set the service to start at boot time. Setting the variable to "false" will cause the script to only exist in the installation directory. /opt/lucee/lucee_ctl for example.

**--installconn**  
**Default Value:** [true]  
This is a BOOLEAN value, meaning it must be true or false.  
This value tells the installer to install the Apache connector. (Ignored on Windows) This variable must be set to [true] if any of the Apache-specific variables are to have any relevance. If this variable is set to [false], the Apache-specific variables will be ignored.

**--apachecontrolloc**  
**Default Value:** [/usr/sbin/apachectl]  
Requires: "--installconn true"  
Specifies the location of the "apachectl" control script.

**--apachemodulesloc**  
**Default Value (RHEL/32):** [/usr/lib/httpd/modules]  
**Default Value (RHEL/64):** [/usr/lib64/httpd/modules]  
**Default Value (Debian/32):** [/usr/lib/apache2/modules]  
**Default Value (Debian/64):** [/usr/lib64/apache2/modules]  
Requires: "--installconn true"  
Specifies the location for new Apache modules. Default value changes depending on default system and the existence of the default directory.

**--apacheconfigloc**  
**Default Value (RHEL):** [/etc/httpd/conf/httpd.conf]  
**Default Value (Debian):** [/etc/apache2/apache2.conf]  
Requires: "--installconn true"  
Specifies the location of the primary Apache configuration script. Global installs for mod_proxy and mod_cfml will be placed in this file.

**--apachelogloc**  
**Default Value (RHEL):** [/var/log/httpd/]  
**Default Value (Debian):** [/var/log/apache2/]  
Requires: "--installconn true"  
Specifies the location of the Apache log files. Used in the configuration of the connector logs for mod_jk.

**--installiis**  
**Default Value:** [true]  
This is a BOOLEAN value, meaning it must be true or false.  
This value tells the installer to install the connector for IIS, the BonCode Connector. (Ignored on Linux) By setting this variable to [true], the Windows Lucee Installer will launch the BonCode Connector installer silently during the install process. You will see several DOS windows pop-up during the connector install process as the BonCode Connector varifies modules and installs what it needs.

### Using an OptionFile ###

The Bitrock InstallBuilder software also supports using an "optionfile" to pass parameters to the Lucee Installer in unattended mode. To use an option file, create a text file (lucee-options.txt in this example) and give it the following content:

```lucee
luceepass=YOURPASSWORDHERE
installdir=/opt/lucee
tomcatport=8888
tomcatshutdownport=8005
tomcatajpport=8009
systemuser=root
startatboot=true
installconn=true
apachecontrolloc=/usr/sbin/apachectl
apachemodulesloc=
apacheconfigloc=
apachelogloc=
installiis=true
```

You may need to remove or change some options for your specific system. Be sure to change the "luceepass" option to your own password.

Once the file is made, run the installer using the option file like so:

	# lucee-[version]-installer.run --mode unattended --optionfile=lucee-options.txt