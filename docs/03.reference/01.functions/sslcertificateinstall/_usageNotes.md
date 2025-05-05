Lucee 5 bundled a caerts file, which caused problems as it was never updated and root certs change, causing SSL errors for normal websites with valid certs.

Lucee 6 by default uses the JVM cacerts file, which currently doesn't work with this function [LDEV-917](https://luceeserver.atlassian.net/browse/LDEV-917)

To use the old behaviour, use `lucee.use.lucee.SSL.TrustStore=true` or `LUCEE_USE_LUCEE_SSL_TRUSTSTORE=true`