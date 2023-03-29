---
title: 3rd Party Libraries
id: 3rd-party-libraries
---

## Overview ##

Lucee ships with a set of 3rd party libraries that help Lucee perform certain tasks like connecting to databases, sending emails, logging, and more. These libraries are found in [lucee-install-folder]\WEB-INF\lib

due to the risk in upgrading one piece of code without thoroughly testing its implications on the whole system, Lucee's policy is to update the libraries shipped with Lucee only in a major version release.

sometimes, however, you need to use a newer library than the one that shipped with Lucee, in order to take advantage of bug fixes and/or new functionality.

keep in mind that if you upgrade a library you risk breaking the code that uses that library as not all libraries are 100% backward compatible, so do it judiciously and only if you must. This practice is Not recommended in a production environment.

## How To Update The Libraries ##

in order to upgrade a library you need to follow these steps:

1. download the new version and place the jar in [lucee-install-folder]\WEB-INF\lib (or any folder that is in the classpath of your servlet container)
1. disable the library with the older version. I usually do it by appending .disable to the file name so it stays in the original folder and I can easily revert my changes if needed.
1. restart Lucee

### Partial Library List ###

Name      |    Packaged Version  | Last Known Version | Project Homepage |
------------------------   | -------------------------
Apache Commons Email   |   1.1  |  1.2   |    [http://commons.apache.org/email/](http://commons.apache.org/email/)   |
Apache Lucene          |  2.4.1 | 3.5.0  |    [http://lucene.apache.org/](http://lucene.apache.org/)          |
H2 Database            |  0.9   | 1.3.164|    [http://www.h2database.com/](http://www.h2database.com/)         |
jTDS                   |  1.2.2 | 1.2.5  |    [http://sourceforge.net/projects/jtds/files/](http://sourceforge.net/projects/jtds/files/) |
SLF4J                  |  1.5.8 | 1.6.4  |   [http://www.slf4j.org/](http://www.slf4j.org/)                       |
