---
title: Installation on CentOS Linux 6 Best Practices
id: linux-installation-on-centos-linux
---

### Installation on CentOS Linux 6 Best Practices ###

**Lucee Installation on CentOS Linux 6 Best Practices**

**Purpose:**

This document is intended for system administrators who want to deploy their Mura CMS, Lucee, Tomcat, and JRE stack in a secure but easy-to-follow manner. This document is not intended to guarantee foolproof security, but rather serve as a set of guidelines for common security-minded best practices. It is important for the reader to understand that no system, no matter how well protected, will ever be 100% guaranteed secure; however, by following these simple guidelines the reader can ensure that their systems will deter the vast majority of common intrusion techniques.

This document will assume that you, the reader, will have basic knowledge of installing CentOS Linux and editing files within it using the editor of your choice.

## Preparing Your Server ##

### 1. Start With a "Blank Slate" ###

It is recommended that your begin by installing a fresh copy of CentOS 6 on to your server. The fresh copy of the Operating System will ensure that there are no lingering abnormalities in the system you'll be installing your Lucee stack on to.

It is also recommended that you perform a "minimal" install of CentOS, as it will mean that only the bare minimum will be installed initially. Anything that you need to add you can add manually. This also means that you won't have any superfluous programs running or even available on the server itself, and again it will minimize the initial attack vectors available on your server.

### 2. Start With a Very Minimal and Restrictive Firewall ###

During the installation process, the CentOS installer will prompt you if you want to configure any initial firewall rules. It is recommended that you both enable the firewall, and only allow the most basic firewall exceptions, such as SSH access (port 21) and HTTP access (port 80). Again, this will minimize the attack vectors that an attacker could exploit.

Once the initial minimal firewall is configured by the installation process, you should only add rules as absolutely necessary and if you can, add incoming IP Address restrictions on them so that only connections coming from approved ranges will be able to connect. For example, the following rule (added by editing the /etc/sysconfig/iptables file which was created by the install process) would restrict who can connect to your SSH port to only a specific Class-C range of IP Addresses:

A RH-Firewall-1-INPUT -m state -state NEW -m tcp -p tcp -dport 22 -s 192.168.254.0/24 -j ACCEPT

Note the line above, the "dport" or "Destination Port" is port 22, which is the default SSH port. Next, note the IP range we used as an example here, which is 192.168.254.0 - a very common internal network range. Please adjust the allowed IP ranges as necessary for your network.

Once you've added or edited the line for the SSH port 22, don't forget to restart the iptables firewall with the following command:

	# /etc/init.d/iptables restart or...

	# service iptables restart Whichever you prefer.

### 3. Install All Available Patches ###

It is important to install all available patches as soon as possible on your new system. You can patch the system manually with the following commands:

	# yum -y upgrade yum # yum -y upgrade

As long as your system has access to the Internet and is able to download files from public repositories, YUM will go download all the latest patches that are available for your system.

The first command updates the YUM program itself. The next line tells YUM to grab all other available updates. Because YUM itself was just updated, it should have the most recent patching information available to it.

### 4. Configure Automatic OS Patching ###

Now that the system is all patched up, we need to configure a process that will run those same updates on a regular basis. I would recommend nightly for the most up-to-date patching. Also, if you run nightly, chances are good that the patch download will be quick and small every time.

To do this, we first need to create a shell script using the text editor of our choice. Let's call it "yumupdate.sh". Now, we need to add the following commands to it:

	#!/bin/bash

	/usr/bin/yum -y upgrade yum /usr/bin/yum -y upgrade

Once you've added those lines, save the file and place it in either of the following directories:

	/etc/cron.daily/yumupdate.sh

	/etc/cron.weekly/yumupdate.sh

Just to be clear, files placed in cron.daily will be run every day, and files placed in cron.weekly will be run each week. The exact time that each are executed is controlled by the /etc/crontab file, which you can also customize as needed.

### Install Minimal Apache Modules ###

As Apache will most likely be your most prominent and most important public-facing server, it is a good idea to keep it as simple as possible to keep attack vectors at a minimum. Don't install modules that you're not sure you'll use, such as PHP, user-directory support, or CGI-BIN support.

### Hide Apache Version Number ###

You can tell Apache to hide it's version number by modifying the "ServerTokens" attribute in the main Apache config file (httpd.conf in RHEL/CentOS or apache2.conf in Debian/Ubuntu):

ServerTokens Prod

Setting this value will cause Apache simply to report "Apache" and not include a version number.

You can also disable the server signature, which is displayed at the bottom of any error messages Apache generates, by using the following parameter:

ServerSignature Off

### 5. Additional Suggestions for the Security-Minded ###

Run SSH on a non-standard port (instead of port 22)

Leave SELinux enabled and create rules to allow Lucee to function through it (Pete Freitag / Foundeo can provide additional assistance in getting SELinux working with Lucee)

### Using the Lucee Installer ###

### 1. Consider a Non-Standard Installation Directory ###

The standard installation directory for Lucee is /opt/lucee/. If an attacker knows this they can craft attacks based off that information. For example, attacks which use parent directory traversal mechanisms, such as '../../opt/lucee/" in the URL's. A non-standard installation directory will simply make your server less vulnerable to customized attacks. Maybe something unpredictable like "/lucee-04-21-78/" or "/opt/cfml/server/luceerocks/"

The downside of this is that documentation is often written with the defaults in mind, and many examples are based on the defaults. As a reader, you will be required to interpolate the default documentation for your own specific environment.

### 2. Be Creative With Your Dedicated Lucee System User ###

It is far more difficult to brute-force a username and password combination if an attacker has no idea where to begin with a username. To that end, be creative when you pick a username for your new Lucee installation. Do not use obvious usernames such as "admin" or "lucee", but still keep it recognisable and memorable. For example, you could call your new Lucee user "theflash", after the speedy but fictional superhero character. You know... because he "runs fast".

### 3. Consider Using a Phrase as a Password ###

Using phrases as passwords is not a new idea, but it is possible to do with Lucee and is a proven method for addressing brute-force password break-ins as well as makes it easy to remember a specific "password". For example, consider the following pass-phrase:

"I always thought about getting 1 but I never did!"

This phrase makes an excellent password. As far as number of characters goes, it's a whopping 49 characters long. It contains a mix of upper and lower-case letters, numbers, and special characters. In the world of passwords, this easy-to-remember phrase is a behemoth, and very unlikely to be brute-forced unless someone knew you were using a phrase and specifically targeted that kind of a pass-phrase. At the time of this writing, most brute-force attacks do not specifically target full phrases.

Even if you don't decide to use a phrase as a password, it's a good idea to use as many characters as you can remember and mix it up with letters (mixed case), numbers, and special characters.

### Locking Down Your Lucee Stack ###

1. **Open Port 8888 Only to a Specific IP** Port 8888 in a default Lucee Installer configuration is the Tomcat web server port. This port is used as the default access point for the Lucee Server Administrator. As the server administrator, you will likely access this URL in order to implement server-wide policy for your Lucee server.

Restrict access to this port to only a single IP via the CentOS firewall by editing the /etc/sysconfig/iptables file and adding a line similar to the following:

A RH-Firewall-1-INPUT -m state -state NEW -m tcp -p tcp -dport 8888 -s 192.168.254.250 -j ACCEPT

As before, edit the "source" IP address by changing 192.168.254.250 to whatever is appropriate for your network.

### 2. Do Not Open Ports 8005 (Shutdown) or 8009 (AJP) to the Public ###

The Lucee 4 BETA3 and newer installers will use mod_proxy_html by default, so the AJP port 8009, while available, is not used by default. If you need to open the AJP port to an external web server in order to connect to it from mod_proxy_ajp or mod_jk, then it is recommend you only open port 8009 to the IP address of the web server that needs to connect to it. You can use a firewall line similar to the example above and change the port and IP to match your network.

The Tomcat Shutdown port - 8005 by default - should not be open to the public. It is recommended that you only initiate Tomcat shutdown commands from the local console.

### 3. Block Access to Lucee Administrators Through Apache ###

In your Apache host configuration for the site or sites you will be serving through Apache and Lucee, you can add the following in order to deny access to all but approved IP's:

<Location "/lucee/admin">

Order deny,allow

Deny from all

Allow from 192.168.254.250

Allow from 127.0.0.1

</Location>

This same concept can be implemented to deny access to the Mura Administrator. If assets in the lucee-context are not needed (eg cfform JavaScript), then you may block the entire /lucee/ instead of just the administrator.

### 4. Lock down Apache and Lucee Users ###

The user accounts that Lucee and Apache run as should be restricted such that they only have the ability to do what the application requires and nothing more. The default shell should be specified to /sbin/nologin prevent login over ssh.

File system permissions should be restricted as well, Apache or Lucee will typically only need read permission for most files in the web root. The execute permission may be required on directories. Lucee and Apache should not be setup to run under the root account.

### 5. Ensure the JVM is up to date ###

Ensure that the JVM version you are using contains all known security patches.

### 6. Additional Suggestions for the Security-Minded: ###

1. Create an additional Apache-based password (.htpasswd) for sensitive areas.
1. Force the use of SSL when accessing the Administrators
1. Disguise Lucee by either using full SES URL's or by replacing the extension to something other then a CFML-related extension. IE: rename your .cfm files to .php and pass .php files off to Lucee for processing.
1. Ensure that the umask has been specified appropriately in the Tomcat/Lucee startup script to prevent it from creating files with more permission than necessary.
1. Consider setting up auditing with auditd
1. If the Tomcat/Apache AJP connector is used specify a shared secret.
Remove any servlet/filter mappings from web.xml that are not required.

### Locking Down Lucee Server ###

### 1. Disable Public Debugging Error Output ###

To disable detailed error messages in Lucee, log in to the Lucee server administrator and go to Settings -> Error -> and select "error-public.cfm" from the drop down options. This will only display an extremely generic and uninformative error message to the end-users.

If you like, you can customise these error templates to send an email off to your development team, informing them that an error occurred and possibly giving them more details about the error.

### 2. Ensure All Administrators for All Contexts Have Passwords Assigned and Use Captcha ###

In the Lucee Server Administrator, go to Security -> Password. From this screen you can set the passwords of all existing web contexts and enable captcha's to prevent brute-forcing password breaking attempts on your Lucee Server & Web Administrators

### 3. Reduce Request Timeouts as Low as Possible ###

To change the Request Timeout value, log in to the Lucee server administrator and go to Settings ->

Application -> Request Timeout. It is recommended you change it from 50 seconds to about 10 or so. Experiment with this to make sure the request timeouts do not effect needed functionality that may exist in your application.

### 4. Ensure Lucee's "Script-Protect" feature is enabled

Lucee's built-in Script-Protect feature is designed to protect your site from cross-site scripting attacks. Script-Protect will automatically filter dangerous tags in incoming variable scopes like CGI, cookie, form, and URL scopes.

To ensure Lucee's Script-Protect feature is enabled, log in to the Lucee server administrator and go to Settings -> Application -> Script-Protect and ensure it's set to "all".

Note: This setting does not provide comprehensive cross-site scripting prevention, additional steps must be taken in your custom source code to alleviate risk.

### 5. Avoid Using System-Heavy Client Variables ###

Instead, try to keep as many variables as possible session-based, so they expire and are removed when the session expires.

### 6. Set Session Timeouts to as Low as Possible ###

This helps free up RAM and prevents some forms of DoS attacks. You can configure session timeout values globally in the Lucee Server Administrator -> Settings -> Application screen.

### 7. Keep Datasource Permissions Simple ###

If you can, only enable SELECT, INSERT, UPDATE, and DELETE permissions. This will almost nullify SQL injection attacks. What commands are accepted by Lucee is configurable for each DSN, and is controlled when you create or edit a DSN.

### 8. Use a Separate DB User for Each DSN ###

Isolating your Database users will help mitigate attacks should a site be found vulnerable. For example should a SQL injection attack occur in one site, the attacker will only have gained the powers of the single Database user account and would only have access to the sites and data for that site - not any other sites that may be present on the system.

### 9. Consider Using a Web Application Firewall (like FuseGuard) ###

Web Application Firewalls are excellent at detecting and deterring attacks on a system. High quality Web Application Firewalls also have the ability to log attacks to let you know what kind of attacks are being directed at your servers, so you can better prepare your defenses. Web Application Firewalls are well worth their initial investment.

Additional information on FuseGuard can be found at this URL:

[http://foundeo.com/security/](http://foundeo.com/security/)

This document prepared by::

Jordan Michaels

Pete Freitag

Matt Levine
