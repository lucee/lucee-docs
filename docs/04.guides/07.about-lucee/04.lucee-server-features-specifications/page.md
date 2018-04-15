---
title: Lucee Features
id: lucee-server-features-specifications
---

## Platform support ##

### OS support ###

Supported on any Java platform.

Installers provided for

* Windows
* OS X
* Linux

WAR file & JAR file deployment versions also available.

### Supported servlet containers ###

* Any servlet container (e.g. Jetty, Tomcat, Glassfish, JBoss, Resin, etc)
* Supplied with Tomcat (installed version) or Jetty (express version)

### Supported web servers ###

* Microsoft IIS
* Apache HTTP server
* Jetty

### Supported Java versions ###

* JRE 6
* JRE 7

## Server features ##

### Clustering & failover ###

* Included in all versions

### Database support ###

* DB2
* Firebird
* H2 Database Engine
* Hypersonic
* Microsoft SQL Server
* MySQL
* ODBC (Access, etc.)
* Oracle
* JDBC
* PostgreSQL
* Sybase

Support for transactions, query caching, stored procedures, etc.

### Virtual file systems supported ###

* Local hard disk
* RAM
* HTTP
* DB
* FTP
* SFTP
* ZIP
* TAR
* Amazon AWS S3

### Mail protocols supported ###

* POP
* SMTP
* IMAP

### Remote comms support ####

* HTTP
* HTTPS
* FTP
* SFTP
Built-in GZIP support for HTTP responses

## Caching ##

### Cache types ###

* Template cache
* Partial template cache
* Database query cache
* Function cache
* User caches

### Supported user caches ###

* RamCache
* EHCache Lite
* EHCache
* CouchDB
* MongoDB
* Memcached
* Infinispan
* Membase

### Search ###

* Apache Lucene included

### Charting, document creation & other media ###

* Charting engine included
* PDF creation included
* Image creation & manipulation included
* Video conversion & playback included

### Extensibility features ###

* Java objects
* web services
* COM

Additional language extensions, frameworks, additional features, drivers, etc. available for automatic download and installation via the Extension Manager.

### Scheduling ###

* Scheduler available programatically or via administrator
* Failed schedules monitored
* Schedule logging

## Language features ##

### CFML compatibility ###

* Version 10

### OOP features ###

* interfaces
* implicit accessors / mutators
* implicit constructors
* ORM (object-relational mapping)

### Error handling ###

* Robust exception handling includings

    * try / catch
    * throwing
    * rethrowing
    * finally
    * catch-all error handling in code
    * site-wide error handling templates

### Security features ###

* Support for NTLM
* HTTPS
* login, logout and role management

## Encryption features ##

### Support for various encryption standards: ###

* CFML specific algorithm
* AES
* BLOWFISH
* DES
* Triple DES

Encodings available:

* Base64
* Hex
* UU

### Data format support ###

* XML
* JSON
* WDDX
* RSS

### Compression algorithms supported ###

* ZIP
* TAR
* TGZ

### Debugging ###

* Integrated debugging templates
    * Customisable output for different groups of users
    * Contents of debug output selectable
    * Determine unused query columns and unscoped variables
* FusionDebug compatible

### Benchmarking and profiling tools ###

* FusionAnalytics compatible

### Editor / IDE support ###

* Supported by various popular editors and IDEs. See [[lucee-editors-IDEs]] & IDEs page.

## Deployment & hosting features ##

### Deployment ###

* Lucee archives
* Secure Lucee archive

### Monitoring support ###

* FusionReactor compatible

### Supported cloud systems ###

(Beanstalk, Amazon EC2, Cloudbees, Jelastic etc.)