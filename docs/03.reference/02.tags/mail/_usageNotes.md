Since Lucee 7.1, mail functionality moved from core to the Mail extension. It is included in the full jar.

## Transport security

Use `useSSL=true` for implicit SSL (typically port 465) or `useTLS=true` for STARTTLS upgrade (typically port 587).

The TLS protocols offered on the wire track the JDK's enabled set, governed by `jdk.tls.disabledAlgorithms`. On Java 11.0.11+, 17+ and 21+ this means TLSv1.2 and TLSv1.3 only — TLSv1.0/1.1 are excluded.

To talk to a legacy mail server that requires older protocols, override via the `mail.smtp.ssl.protocols` system property or environment variable, e.g. `-Dmail.smtp.ssl.protocols=TLSv1`. Lucee passes this through to Jakarta Mail unchanged.

Changed in Lucee 6.2.7.15 / 7.0.4.33 / mail extension 1.1.0.6: previously the STARTTLS path re-enabled deprecated protocols the JDK had disabled. See [LDEV-5893](https://luceeserver.atlassian.net/browse/LDEV-5893).
