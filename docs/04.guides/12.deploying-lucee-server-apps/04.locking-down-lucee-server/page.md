---
title: 'Locking Down Lucee '
id: locking-down-lucee-server
categories:
- server
description: Security best practises to lock down your Lucee server
---

### Secure the WEB-INF directory for every web context

Make sure the WEB-INF directory is locked down. You will need to configure your webserver to restrict access, or configure the WEB-INF directories to be stored outside the web root into a common folder, [[relocating-web-inf]]

### Disable Public Debugging Error Output ###

To disable detailed error messages in Lucee, log in to the Lucee server administrator and go to Settings -> Error -> and select "error-public.cfm" from the drop down options. This will only display an extremely generic and uninformative error message to the end-users.

### Ensure All Administrators for All Contexts Have Passwords Assigned and Use Captcha ###

In the Lucee Server Administrator, go to Security -> Password. From this screen you can set the passwords of all existing web contexts and enable captcha's to prevent brute-forcing password breaking attempts on your Lucee Server & Web Administrators

### Reduce Request Timeouts as Low as Possible ###

To change the Request Timeout value, log in to the Lucee server administrator and go to Settings -> Application -> Request Timeout. It is recommended you change it from 50 seconds to about 10 or so. Experiment with this to make sure the request timeouts do not effect needed functionality that may exist in your application.

### Ensure Lucee's "Script-Protect" feature is enabled ###

Lucee's built-in Script-Protect feature is designed to protect your site from cross-site scripting attacks. Script-Protect will automatically filter dangerous tags in incoming variable scopes like CGI, cookie, form, and URL scopes.

To ensure Lucee's Script-Protect feature is enabled, log in to the Lucee server administrator and go to Settings -> Application -> Script-Protect and ensure it's set to "all".

Note: This setting does not provide comprehensive cross-site scripting prevention, additional steps must be taken in your custom source code to alleviate risk.

### Avoid Using System-Heavy Client Variables ###

Instead, try to keep as many variables as possible session-based, so they expire and are removed when the session expires.

### Set Session Timeouts to as Low as Possible ###

This helps free up RAM and prevents some forms of DoS attacks. You can configure session timeout values globally in the Lucee Server Administrator -> Settings -> Scope screen.

Setting all the available scopes to a value as low as possible is a good idea.

### Keep Datasource Permissions Simple ###

If you can, only enable SELECT, INSERT, UPDATE, and DELETE permissions. This will almost nullify SQL injection attacks. What commands are accepted by Lucee is configurable for each DSN, and is controlled when you create or edit a DSN.

### Use a Separate DB User for Each DSN ###

Isolating your Database users will help mitigate attacks should a site be found vulnerable. For example should a SQL injection attack occur in one site, the attacker will only have gained the powers of the single Database user account and would only have access to the sites and data for that site - not any other sites that may be present on the system.

### Consider Using a Web Application Firewall (like FuseGuard) ###

Web Application Firewalls are excellent at detecting and deterring attacks on a system. High quality Web Application Firewalls also have the ability to log attacks to let you know what kind of attacks are being directed at your servers, so you can better prepare your defenses. Web Application Firewalls are well worth their initial investment.

Additional information on FuseGuard can be found at this URL: [http://foundeo.com/security/](http://foundeo.com/security/)

See also:

- [[locking-down-your-lucee-stack]]
- [[running-lucee-installing-the-boncode-connector-and-mod_cfml]]
