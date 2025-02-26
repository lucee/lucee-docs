---
title: System Requirements Linux
id: linux-system-requirements
---

The Lucee Installer for Linux has been tested on many systems, and should function on **most** Linux systems, but for those who prefer to have a list, the following are what we build and test on.

**IMPORTANT:** Lucee itself is not limited in any way by the Operating System. Lucee can run anywhere that a JVM runs, which is, at this point, all modern systems. This list is purely talking about the Lucee installer for Linux.

### Installer OS Support ###

The Lucee Installer has been tested on following Linux OS's and are known to work without any known issues:

* Almalinux 8 / 9
* Rocky Linux 9 / 9
* Redhat Enterprise Linux 8 / 9
* Debian 10 / 11 / 12
* Fedora 38/ 39 / 40 / 41
* Ubuntu 20.X / 21.X / 22.X
* Pop!_OS
* Mint Linux
* Slackware
* OpenSuse
* Zorin

additional Linux OS's should work just fine provided that the Apache directories are specified correctly during the install process.
  
### Memory ###

It's important to realize that the memory requirements stated here are for Lucee and Tomcat *only*. Your server will require additional memory to support the OS, as well as memory for your own applications.

* Minimum: 128 MB RAM
* Recommended: 256 MB RAM or greater.

### Disk Space ###

* Just over 200MB Disk Space after install (300MB for installer plus install process)

### Apache Support ###

* Apache 2.4
* Apache 2.2
* Apache 2.0
* Apache 1.3 support has been discontinued.

### NGINX Support ###

* Requires manual configuration of NGINX

### Tomcat Support ###
* Tomcat 9.X
