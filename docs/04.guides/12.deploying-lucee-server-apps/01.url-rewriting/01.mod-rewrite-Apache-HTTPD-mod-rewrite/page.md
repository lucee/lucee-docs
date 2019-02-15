---
title: Installation URLRewriting mod_rewrite
id: mod-rewrite-Apache-HTTPD-mod-rewrite
---

### mod_proxy Examples ###

Load balanced cluster example which only proxies CFML files:

```lucee
ProxyPreserveHost On
ProxyPassReverse / balancer://tom_cluster/
RewriteEngine On
# uncomment below RewriteCond for "verify file exists" functionality:
#RewriteCond  %{DOCUMENT_ROOT}/$1  -f
# Proxy CFML requests (barring the admin) to Tomcat:
RewriteCond %{REQUEST_fileNAME} !^\/lucee/admin.*
RewriteRule  ^/(.*\.cf[cm]l?)(/.*)?$  balancer://tom_cluster/$1$2  [P]
```

### Security Related Rewrites ###

Security rewrites (used to block unwanted traffic). Builds on above example to optionally capture these requests to a cfml page, otherwise /security-violation.htm should resolve to something:

```lucee
RewriteEngine on
RewriteRule .*NVARCHAR.* /security-violation.htm [NC]
RewriteRule .*DECLARE.* /security-violation.htm [NC]
RewriteRule .*INSERT.* /security-violation.htm [NC]
RewriteRule .*xp_.* /security-violation.htm [NC]
RewriteRule .*@.* /security-violation.htm [NC]
RewriteRule .*‚Äô;* /security-violation.htm [NC]
RewriteRule .*EXEC\(@.* /security-violation.htm [NC]
RewriteRule .*sp_password.* /security-violation.htm [NC]
RewriteRule /security-violation.htm /security-violation.cfm [L]

RewriteCond %{QUERY_STRING} .*http:\/\/.* [NC]
RewriteRule .* /security-violation.htm
RewriteCond %{QUERY_STRING} .*sp_password.* [NC]
RewriteRule .* /security-violation.htm
RewriteCond %{QUERY_STRING} .*@@.* [NC]
RewriteRule .* /security-violation.htm
RewriteCond %{QUERY_STRING} .*'.* [NC]RewriteRule .* /security-violation.htm
RewriteCond %{QUERY_STRING} .*CHAR\(.* [NC]
RewriteRule .* /security-violation.htm
RewriteCond %{QUERY_STRING} .*CAST\(.* [NC]
RewriteRule .* /security-violation.htm
RewriteCond %{QUERY_STRING} .*EXEC\(@.* [NC]
RewriteRule .* /security-violation.htm
RewriteCond %{QUERY_STRING} .*DECLARE.* [NC]
RewriteRule .* /security-violation.htm

uncomment to use the specified cfm pageRewriteRule /security-violation.htm balancer://tom_cluster/security-violation.cfm [P,L]

RewriteCond %{REQUEST_METHOD} ^(delete|head|trace|track) [NC]
RewriteRule ^(.*)$ - [F,L]

RewriteCond %{HTTP_COOKIE} ^.*(<|>|'|%0A|%0D|%27|%3C|%3E|%00).* [NC]
RewriteRule ^(.*)$ - [F,L]
 
RewriteCond %{HTTP_USER_AGENT} ^$                                                              [OR]
RewriteCond %{HTTP_USER_AGENT} ^.*(<|>|'|%0A|%0D|%27|%3C|%3E|%00).*                            [NC,OR]
RewriteCond %{HTTP_USER_AGENT} ^.*(HTTrack|clshttp|archiver|loader|email|nikto|miner|python).* [NC,OR]
RewriteCond %{HTTP_USER_AGENT} ^.*(winhttp|libwww\-perl|curl|wget|harvest|scan|grab|extract).* [NC]
RewriteRule ^(.*)$ - [F,L]
 
RewriteCond %{HTTP_REFERER} ^(.*)(<|>|'|%0A|%0D|%27|%3C|%3E|%00).* [NC,OR]
RewriteCond %{HTTP_REFERER} ^http://(www\.)?.*(-|.)?adult(-|.).*$  [NC,OR]
RewriteCond %{HTTP_REFERER} ^http://(www\.)?.*(-|.)?poker(-|.).*$  [NC,OR]
RewriteCond %{HTTP_REFERER} ^http://(www\.)?.*(-|.)?drugs(-|.).*$  [NC]
RewriteRule ^(.*)$ - [F,L]
```
