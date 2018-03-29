---
title: Lockdown Guide
id: cookbook-lockdown-guide
---

# Lockdown Guide #
A guide to limit access to a Lucee server to necessary minimum.



On Windows it is recommended to run the Lucee/Tomcat service as a restricted user with only the required permissions rather than under SYSTEM account.

## Restricted Access Plus SSH Tunnelling ##

As with ACF, it is recommended best security practice to restrict access to URI's that are not necessary to publicly expose.

Examples that have been cited include:

* /lucee
* /WEB-INF
* /META-INF

If using Tomcat, then also restrict access to the following URIs that are installed by default by Tomcat:

* /manager
* /host-manager

An Apache directive that restricts access to /lucee, as an example, is given below:

    <Location /lucee>
        Order Deny,Allow
        Deny from all
        Allow from 127.0.0.1
    </Location>

In the above example, only the localhost IP address, 127.0.0.1, would be allowed to navigate to any url that contains /lucee. This directive effectively blocks access to URL's that begin with /lucee/ from any other IP address, cutting off any exploits that attempt to use resources located under /lucee.

So far, so good. But then how can admins access the admin panels such as /lucee/admin/server.cfm if they don't have physical access to the server???

There is a relatively simple technique called SSH tunneling which will allow an administrator to log into a web server with URI's restricted to 127.0.0.1 as in the above directive. In a nutshell, the admin logs onto the server using SSH with the -D flag and a free local port of your choice, and then sets up a browser to use the server, via the local port specified, as a proxy. The net effect is that once the admin is logged into the server via SSH and has the browser properly set, browsing to 127.0.0.1/lucee/admin/server.cfm opens the login screen on the server, not on the local machine!

This approach allows one to lock down potentially vulnerable URI's and still allow an admin to access them securely, _over an encrypted connection_, from any IP address, no matter where they happen to be when a difficulty with the server arises. An encrypted connection is an added bonus because it will prevent a hacker from gaining access to the admin credentials if your internet connection is compromised in some way with a packet sniffer, for instance. And SSH tunneling is _much_ easier to setup compared to configuring HTTPS for /lucee/ access. And it is much more portable! You can leave a particular browser set up to use a proxy connection, as detailed below, simply add the -D flag when shhing into a server, and you can use this technique to securely access a restricted admin area of any number of servers.

Detailed instructions for SSH tunneling:

1) ssh into a server using the -D flag, example: ssh -D 60001 user@102.103.108.39

2) In your web browser, setup your proxy to point to "localhost", your port (for our example our port is 60001), using SOCKS5. This should work with any browser. Using Firefox as an example, here's how to do that:

* Go to Preferences
* Click the Advanced icon
* Click the Network tab
* Click the Settings button, across from where it says "Configure how Firefox connects to the Internet
* Select Manual proxy configuration
* In the SOCKS Host field put "localhost" without the quotation marks
* In the Port field put the port number you used in the -D flag, 60001 in our example
* Select SOCKS v5
* Click OK

3) To revert the browser to normal behavior, simply choose No Proxy in the Network Settings dialog

4) Note that the port chosen is arbitrary, it only has to be available and match in both the -D flag and SOCKS port setting.


## Some Good Resources written for Railo that can be adapted for Lucee ##

* [OWASP Securing Tomcat](https://www.owasp.org/index.php/Securing_tomcat)
* [Railo installation on CentOS Best Practices](http://blog.getrailo.com/assets/content/RailoInstallationonCentOSLinux6BestPractices.pdf)
* [Railo Admin Lock down guide for IIS (What can be adapted)](https://www.youtube.com/watch?v=dYt4rap7LWQ)
* [Pete Freitag on securing railo-context](http://www.petefreitag.com/item/715.cfm)
