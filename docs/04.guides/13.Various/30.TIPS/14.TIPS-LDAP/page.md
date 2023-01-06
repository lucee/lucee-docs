---
title: Setting Up Secure LDAP
id: tips-LDAP
related:
- tag-ldap
---

### Setting up Secure LDAP ###

Import the SSL Certificate for your LDAP sever via the command line:

* `{jre bin directory}\keytool -import -keystore c:\{path_to_lucee}\jre\lib\security\cacerts* -alias mySSLCert -storepass changeit -noprompt -trustcacerts -file c:\mySSLCert .cert`

* Do the same with ROOT/Intermediate Certificate (may not be required).

* `{jre bin directory}\keytool -import -keystore c:\{path_to_lucee}\jre\lib\security\cacerts* -alias mySSLCert -storepass changeit -noprompt -trustcacerts -file c:\mySSLCert .cert`

Since Lucee 6.0, rather than using the bundled `cacerts` file (which doesn't get automatically updated), the JRE's `cacerts` file is used by default. 

So change the path above (i.e. `c:\{path_to_lucee}\jre`) to point to your `JAVA_HOME`. 

To use the old behavior, i.e. the Lucee file cacerts with 6.0, set `lucee.use.lucee.SSL.TrustStore=true`

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
