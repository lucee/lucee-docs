---
title: Locking Down your Stack
id: locking-down-your-lucee-stack
---

### Restrict Access to Tomcat's Web Server ###

Port 8888 in a default Lucee Installer configuration is the Tomcat web server port. This port is used as the default access point for the Lucee Server Administrator. As the server administrator, you will likely access this URL in order to implement server-wide policy for your Lucee server.

You can restrict access to this port to only a single IP on a RHEL/CentOS firewall by editing the /etc/sysconfig/iptables file and adding a line similar to the following:

	-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 8888 -s 192.168.254.250 -j ACCEPT

As before, edit the "source" IP address by changing 192.168.254.250 to whatever is appropriate for your network.

### Keep Tomcat Ports Private ###

By default, Tomcat has two additional ports that it listens for connections on besides the web server port, which listens on port 8888 by default. Tomcat's additional ports are the Shutdown Port, which is port 8005 by default, and the AJP port, which is port 8009 by default. For the AJP port, it is recommend you only open port 8009 to the IP address of the web server that needs to connect to it. The Tomcat Shutdown port should not be open to the public. It is recommended that you only initiate Tomcat shutdown commands from the local console.


Block Public Access to the Lucee Administrators

If you are using RHEL/CentOS, you can add the following to your Apache config in order to deny access to all but approved IP's:

```lucee
<Location /lucee/admin>
Order deny,allow
Deny from all
Allow from 192.168.254.250
Allow from 127.0.0.1
</location>
```

If assets in the lucee-context are not needed (ie: if you're not using cfform or something similar), then you may block the entire /lucee/ instead of just the administrator subdirectory.


### Ensure the JVM is up to Date ###

Always ensure that your JVM is up to date to the latest JVM security baseline. Instructions for upgrading your JVM are available for both Windows and Linux

You can subscribe to get email alerts for Java Security releases by following the instructions found here: [http://www.oracle.com/technetwork/topics/security/securityemail-090378.html](http://www.oracle.com/technetwork/topics/security/securityemail-090378.html)


### Ensure Tomcat is up to Date ###

Tomcat is the servlet engine that the Lucee Installers use by default. From time to time, security issues are discovered and fixed within Tomcat. Therefore, it is a good idea to keep an eye on the Security Releases for Tomcat and apply them when needed.

Instructions for upgrading Tomcat are available for both Windows and Linux

To stay informed of new Tomcat releases, you can subscribe to the Tomcat-Announce mailing list: [http://tomcat.apache.org/lists.html#tomcat-announce](http://tomcat.apache.org/lists.html#tomcat-announce)


Additional Suggestions

* Create an additional Apache-based password (.htpasswd) for sensitive areas.  
* Force the use of SSL when accessing the Administrators  
* Disguise Lucee by either using full SES URL's or by replacing the extension to something other then a CFML-related extension. IE: rename your .cfm files to .php and pass .php files off to Lucee for processing.
* [[lucee-lockdown-guide]]
