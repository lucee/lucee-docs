---
title: TIPS Use cfmail with SSL authentication
id: tips-cfmail-SSL-authentication
---

More and more mail servers requires SSL authentication to send emails. Usually you send mail like
```lucee
<cfmail server="smtp.server.com" usessl="true" port="465" ...>
```
 You may need to add a mail server certificate into Lucee JRE environment to avoid connection errors like this one: 
```lucee
PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
```

* Add certificate to Lucee itself. Go to Lucee Server Administrator -> Services -> SSL certificates

```lucee
Host: smtp.server.com - for example
```

```lucee
port:465
```

* Fetch and Install certificate into JRE environment (path to Lucee JRE, for example /opt/lucee/jdk/) fetch on Linux:

```lucee
openssl s_client -connect smtp.server.com:465 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /opt/smtp-mail-public.crt
```

fetch on Windows (or get certificate and save to local file without command line):

```lucee
	openssl s_client -connect smtp.server.com:465 < NUL | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > C:/smtp-mail-public.crt
```

Now we have a certificate file. Install with a JRE keytool:

```lucee
/opt/lucee/jdk/jre/bin/keytool -import -alias smtp.server.com -keystore /opt/lucee/jdk/jre/lib/security/cacerts -file 	/opt/smtp-mail-public.crt
```
The default prompted password for keystore is changeit

* Restart Lucee to apply changes. ```<cfmail server="smtp.server.com" usessl="true" port="465" ...>``` should work now.

Do not forget to repeat steps 2) and 3) if you decide to upgrade JRE version by replacing JRE folder.