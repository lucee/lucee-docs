---
title: Lucee Lockdown Guide
id: lucee-lockdown-guide
---

### Some Good Resources ###

* [[locking-down-your-lucee-stack]]

* OWASP Securing Tomcat: [https://www.owasp.org/index.php/Securing_tomcat](https://www.owasp.org/index.php/Securing_tomcat)

* Lucee Admin Lock down guide for IIS : [https://www.youtube.com/watch?v=dYt4rap7LWQ](https://www.youtube.com/watch?v=dYt4rap7LWQ)

* Pete Freitag on securing lucee-context : [http://www.petefreitag.com/item/715.cfm](http://www.petefreitag.com/item/715.cfm)

On Windows it is recommended to run the Lucee/Tomcat service as a restrict user with only the required permissions rather than under SYSTEM account.

## Disabling the Lucee Administrator ##

If the enviroment variable LUCEE_ADMIN_ENABLED is set to false, the Lucee Administrator is disabled, since 5.3.3.45 (requires a Lucee restart to pick up changes)

## Restrict Access to the Lucee Administrator and other folders ##

As with ACF, the recommended best security practice to restrict access to all URLs that are not required to be publically accessible.

Examples that have been cited include:

* /lucee
* /manager
* /host-manager
* /WEB-INF (see [[relocating-web-inf]] )
* /META-INF

An Apache directive that restricts access to /lucee, as an example, is given below:

```lucee
<Location /lucee>
    Order Deny,Allow
    Deny from all
    Allow from 127.0.0.1
</Location>
```

It's important that this rule is applied to all websites

In the above example, only the localhost IP address, 127.0.0.1, would be allowed to navigate to any url that contains /lucee. This directive effectively blocks access to URL's that begin with /lucee/ from any other IP address, cutting off any exploits that attempt to use resources located under /lucee.

## SSH Tunnelling or Remote Desktop ##

So far, so good. But then how can admins access the admin panels such as /lucee/admin/server.cfm if they don't have physical access to the server???

You can either login to your server via Remote Desktop or by using a SSH tunnel.

There is a relatively simple technique called SSH tunneling which will allow an administrator to log into a web server with URI's restricted to 127.0.0.1 as in the above directive. In a nutshell, the admin logs onto the server using SSH with the -D flag and a free local port of your choice, and then sets up a browser to use the server, via the local port specified, as a proxy. The net effect is that once the admin is logged into the server via SSH and has the browser properly set, browsing to 127.0.0.1/lucee/admin/server.cfm opens the login screen on the server, not on the local machine!

This approach allows one to lock down potentially vulnerable URI's and still allow an admin to access them securely, over an encrypted connection, from any IP address, no matter where they happen to be when a difficulty with the server arises. An encrypted connection is an added bonus, because it will prevent a hacker from gaining access to the admin credentials if your internet connection is compromised in some way with a packet sniffer, for instance. And SSH tunneling is much easier to setup compared to configuring https for /lucee/ access. And it is much more portable! You can leave a particular browser set up to use a proxy connection, as detailed below, simply add the -D flag when shhing into a server, and you can use this technique to securely access a restricted admin area of any number of servers.

Detailed instructions for SSH tunneling:

1. ssh into a server using the -D flag, example: ssh -D 60001 user@102.103.108.39

2. In your web browser, setup your proxy to point to "localhost", your port (for our example our port is 60001), using SOCKS5. This should work with any browser. Using Firefox as an example, here's how to do that:

* Go to Preferences
* Click the Advanced icon
* Click the Network tab
* Click the Settings button, across from where it says "Configure how Firefox connects to the Internet
* Select Manual proxy configuration
* In the SOCKS Host field put "localhost" without the quotation marks
* In the Port field put the port number you used in the -D flag, 60001 in our example
* Select SOCKS v5
* Click OK

1. To revert the browser to normal behavior, simply choose No Proxy in the Network Settings dialog

1. Note that the port chosen is arbitrary, it only has to be available and match in both the -D flag and SOCKS port setting.
