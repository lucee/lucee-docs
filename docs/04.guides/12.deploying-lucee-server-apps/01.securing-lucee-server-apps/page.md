---
title: Security
id: securing-lucee-server-apps
---


## Security ##

### Basics ###

* Use a sitewide error handler, so you do not disclose sensitive information about your system.
* Use SSL if you have users logging into your site, even if it's a self-signed cert. Secure your cookies.
* Run Lucee under a dedicated user with limited access
* Remove the Lucee admin files if not needed
* lots of other stuff. Search for "hardening coldfusion"

## Validate user input, sanitize user output ##

Anything that goes into your system should be validated upon entry. Do not transparently sanitize user input -- either accept it or reject it -- and instead sanitize the output. This keeps your data pure, will not surprise you later with changed input, and consolidates sanitation logic. However, you must validate and escape anything that can effect the chosen method of data persistence. In the case of a SQL database this means using cfqueryparam on any variable a user could possibly set (use it everywhere! The binding should improve performance too). If it were a CVS file using quotes for delimiters, you would escape the quotes... and so on and so forth. You are focused only on getting the data in safely. When you have an original, you can do whatever you like to copies!

Upon output, sanitize HTML with xmlFormat() or htmlEditFormat(), sanitize any URLs (meaning if you're accessing a 3rd party REST endpoint using user-supplied input, for instance, or not using htmlEditFormat()) with urlEncodedFormat(), sanitize any shell commands based on whatever shell they'll be running in... it's the same concept as escaping/sanitizing for the persistence format, but in reverse, for the output format. Every point in the process should only care about the next step-- if you try to escape for something three steps away, you can inadvertently open holes instead of close them

## Doing things based on IP address ##


One method of doing things based on IP addresses is [[url-rewriting]]. Another is using a front end web server, or the servlet container itself to manage access. Yet another, which is really the same as the first, is to use the URLRewriteFilter servlet filter.

The nice thing about the URLRewriteFilter, is that it is not servlet container specific. The same WAR will deploy with the same rules anywhere the WAR runs, be it JBoss/Tomcat, Jetty, Resin, or GlassFish.

Set IPs allowed to see debugging output in the Lucee Administrator.

Example URLRewriteFilter rewrite only allowing localhost to access the admin:


```lucee
<rule enabled="true">
   <name>luceeLocalOnly</name>
   <note>Only allow access to lucee admin from localhost</note>
   <condition operator="notequal" type="remote-addr">127\.0\.0\.1|0:0:0:0:0:0:0:1%0</condition>
   <from casesensitive="false">^.*/lucee-context/admin/.*</from>
   <to last="true" type="forward">/</to>
</rule>
```

One way of many to achieve the same for httpd, using mod_rewrite:

```lucee
RewriteCond %{REMOTE_ADDR}       !=127\.0\.0\.1
RewriteRule ^.*/lucee-context/admin/   -   [F]
```

## Realms and whatnot ##

And then there's [Realms and whatnot](http://docs.oracle.com/javaee/6/tutorial/doc/bnbxj.html), the Java security stuff which is part of the servlet spec.

## Other options ##

There's the WS-Security standard, with a project implementing this for CFML here http://wss4cf.riaforge.org/ as well. Check out [OWASP](https://www.owasp.org/index.php/ColdFusion_Security_Resources). Terminology: [CSRF](http://en.wikipedia.org/wiki/Cross-site_request_forgery) [XSS](http://en.wikipedia.org/wiki/Cross-site_scripting) [SQL Injection](http://en.wikipedia.org/wiki/SQL_injection)

### More Resources ###

[[lucee-lockdown-guide]]