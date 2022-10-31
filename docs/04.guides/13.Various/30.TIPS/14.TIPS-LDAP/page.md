---
title: Setting Up Secure LDAP
id: tips-LDAP
related:
- tag-ldap
---

### Setting up Secure LDAP ###

Import the SSL Certificate for your LDAP sever via the command line:

* `{jdk bin directory}\keytool -import -keystore c:\{path_to_lucee}\jre\lib\security\cacerts* -alias mySSLCert -storepass changeit -noprompt -trustcacerts -file c:\mySSLCert .cert`

* Do the same with ROOT/Intermediate Certificate.

* `{jdk bin directory}\keytool -import -keystore c:\{path_to_lucee}\jre\lib\security\cacerts* -alias mySSLCert -storepass changeit -noprompt -trustcacerts -file c:\mySSLCert .cert`

Since Lucee 6.0, rather than using the bundles cacerts file, the bundled JRE cacerts file is used, so you need to change the path to cacerts. 

To use the Lucee file cacerts with 6.0, set `lucee.use.lucee.SSL.TrustStore<=true`

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
