<!--
{
  "title": "Sending Emails",
  "id": "mail-how-to-send-a-mail",
  "related": [
    "tag-imap",
    "tag-mail",
    "tag-mailparam",
    "tag-mailpart",
    "mail-listeners"
  ],
  "description": "How to send an email using Lucee with help of the tag cfmail.",
  "keywords": [
    "Email",
    "Send mail",
    "cfmail",
    "Mail server",
    "Mail script",
    "Lucee"
  ],
  "categories": [
    "protocols",
    "core"
  ]
}
-->

# Sending Emails

Send emails using [[tag-mail]]. Mail server configuration options:

- Default server in Lucee Administrator / `CFConfig.json`
- Application-specific server in [[tag-application]]
- Direct attributes on [[tag-mail]] (`server`, `port`, etc.)

## Tags

```coldfusion
<cfmail subject="Your Order" from="whatever@lucee.org" to="whatever@gmail.com">
  Hi there,
  This mail is sent to confirm that we have received your order.
</cfmail>
```

## Script

```cfs
mail subject="Your Order" from="whatever@lucee.org" to="whatever@gmail.com" {
  writeOutput('Hi there,');
  writeOutput('This mail is sent to confirm that we have received your order.');
};
```

## Addressing

You can pass in a list of email addresses, either bare or with titles, use quotes if the title contains a special character

- `lucee1@example.com`
- `"Server, Lucee" <lucee2@example.com>`
- `Lucee Server <lucee3@example.com>`

```coldfusion
<cfmail subject="hello world" 
  to='lucee1@example.com,"Server, Lucee"<lucee2@example.com>,Lucee Server<lucee3@example.com>'.....>
Hello Possums
</cfmail>
```

## Securing the connection

Two boolean attributes on [[tag-mail]] control transport security:

- `useSSL=true` — implicit SSL from the first byte (typically port 465).
- `useTLS=true` — start in plain SMTP and upgrade via STARTTLS (typically port 587).

Pick whichever your provider offers; most support both.

```cfs
mail subject="hello" from="x@example.com" to="y@example.com"
  server="smtp.example.com" port=587 useTLS=true
  username="x@example.com" password="..." {
  writeOutput('TLS-secured send');
};
```

### TLS protocol policy

As of [LDEV-5893](https://luceeserver.atlassian.net/browse/LDEV-5893) (Lucee 6.2.7.15, 7.0.4.33, mail extension 1.1.0.6), Lucee tracks the JDK's enabled TLS protocols rather than overriding them. On Java 11.0.11+, 17+ and 21+ that means TLSv1.2 and TLSv1.3 are offered — TLSv1.0/1.1 are excluded because the JDK disables them in `jdk.tls.disabledAlgorithms`.

Before this change, the STARTTLS path re-enabled deprecated protocols the JDK had switched off; the other secure paths (`useSSL`, `cfimap secure=true`, `cfpop secure=true`) already inherited JDK defaults.

If you need to talk to a legacy mail server that only supports older protocols, override the list via system property or environment variable:

```text
-Dmail.smtp.ssl.protocols=TLSv1
```

Lucee yields to this override and passes the value through to Jakarta Mail unchanged.

### Trusting the server certificate

Connecting to a mail server with a self-signed or internally-issued certificate fails with:

```text
PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException:
unable to find valid certification path to requested target
```

Either trust the certificate:

- **Lucee Administrator** — Server Administrator → Services → SSL certificates. Enter the host and port, fetch, and install. No restart needed.
- **JVM truststore (headless)** — fetch the cert and import via `keytool`:

```text
openssl s_client -connect smtp.example.com:465 </dev/null \
  | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > smtp.crt

keytool -import -alias smtp.example.com \
  -keystore $JAVA_HOME/lib/security/cacerts \
  -file smtp.crt
```

Default `cacerts` password is `changeit`. Re-run after every JRE upgrade if you replace the JRE folder.

## Spooling

By default Lucee spools mails and sends them out via a background thread, for better performance.

If you need to send the mail immediately, or need catch any SMTP errors, use `async="false"` which will send the email immediately and throw an errors encountered which will otherwise be caught and logged to the `remoteclient.log`

```cfs
mail subject="Your Order" from="whatever@lucee.org" to="whatever@gmail.com" async="false" {
  writeOutput('Hi there,');
  writeOutput('This mail is sent to confirm that we have received your order.');
};
```
