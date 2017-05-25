---
title: System Requirements
id: windows-system-requirements
---

### Installation InstallerDocumentation MSSystemReq ###

The Lucee Installer for Windows has been tested on many systems, and should function on *most* Windows systems, but for those who prefer to have a list, the following are what we build and test on.

**IMPORTANT:** Lucee itself is not limited in any way by the Operating System. Lucee can run anywhere that a JVM runs, which is, at this point, all modern systems. This list is purely talking about the Lucee Installer for Windows.

### Windows Installer OS Support ###

The following Windows OS's have been tested and are known to work without issues:

* Windows Server 2008 (32-bit/64-bit)
* Windows Server 2008 R2 (64-bit)
* Windows Server 2003 (32-bit/64-bit)
* Windows 7 Professional/Ultimate (32-bit/64-bit)
* Windows Vista Business/Ultimate (32-bit/64-bit)
* **Windows XP is not supported.**

### Memory ###

It's important to realize that the memory requirements stated here are for the OS along with the Lucee/Tomcat engine. The bulk of the memory required here will be used for the OS, as a fresh install of Lucee on Tomcat (no applications running on it yet) will only need 64MB to 128MB to start up and only utilize roughly 50MB of RAM after startup.

* Windows 2008: 1GB RAM Required. 2GB RAM or more recommended.
* Windows 2003/7/Vista: 512MB RAM Required. 2GB RAM or more recommended.

### Disk Space ###

* Just over 200MB Disk Space after install (300MB for installer plus install process)

### IIS Support ###

* IIS 6 on Windows 2003
* IIS 7 on Windows 2008
* IIS 7.5 on Windows 2008 R2

### IIS Module Requirements ###

While Tomcat does include it's own web server, most System Administrators and Control Panels do not support Tomcat's built-in web server. Additionally, if you w like to run ASP.NET or another web language technology (such as PHP), it is generally recommended to use IIS as your front-end web server and have it worry about what languages get processed by what server. For those of you who want or need to use IIS as your front-end web server, you will need both IIS installed, as well as the "ISAPI Extensions" and "ISAPI Filters" modules installed. This is true for both IIS6 and IIS7.