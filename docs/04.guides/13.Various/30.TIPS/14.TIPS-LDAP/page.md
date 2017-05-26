---
title: TIPS Setting_Up_Secure_LDAP
id: tips-LDAP
---

### Setting up Secure LDAP ###

Import the SSL Certificate for ldap via command line:

* {jdk bin directory}\keytool -import -keystore c:\{path_to_lucee}\jdk\lib\security\cacerts* -alias mySSLCert -storepass changeit -noprompt -trustcacerts -file c:\mySSLCert .cert

* Do the same with ROOT/Intermediate Certificate.

* {jdk bin directory}\keytool -import -keystore c:\{path_to_webserver}\WEB-INF\lucee\security\cacerts* -alias mySSLCert -storepass changeit -noprompt -trustcacerts -file c:\mySSLCert .cert

* Do the same with ROOT/Intermediate Certificate.

* {jdk bin directory}\keytool -import -keystore c:\{path_to_tomcat_root}\webapps\ROOT\WEB-INF\lucee\security\cacerts* -alias mySSLCert -storepass changeit -noprompt -trustcacerts -file c:\mySSLCert .cert
Do the same with ROOT/Intermediate Certificate.

### Example usage with CFLDAP tag: ###

```lucee
<cfldap name="GetList"
	server="ldap.myorganization.com"
	action="query"
	attributes="*"
	scope="subtree"
	secure="CFSSL_BASIC"
	port="636"
	username="uid=#myUserName#,ou=People,o=My Organization,c=US"
	password="#password#" 
	filter="cn=*#searchForName#*"
	maxrows="100"
	start="o=My Organization, c=US">
<cfdump var="#getList#">
```