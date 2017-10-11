---
title: Installation
id: installation-installer-documentation
---

### Lucee Installer Documentation ###

The Lucee Installer was created with the hope that it would make the deployment of Lucee a very simple process. The Installer creates a stand-alone instance of Lucee, Tomcat, and Oracle's JRE 1.7 specifically for use with Lucee. It can be run "by itself" or it can be connected to a pre-installed web server: IIS on Windows and Apache on Linux. This installer also performs the web-server to Tomcat server connections for you, which can be customized at any point after the install to meet your own unique needs.

### Mailing Lists: ###

If you do not find the answers you are looking for here, we encourage you to post to Lucee Mailing List. There are many friendly members of the community who are willing to help:

* [Lucee Open Source Community Mailing List](http://groups.google.com/group/lucee/)

### General Information ###

* [[installation-release]]
* [[installation-credits]]
* [[installer-translation]]

### Installing and Upgrading ###

**Windows**

* [[windows-system-requirements]]
* [[windows-launching-the-installer]]
* [[windows-manually-upgrading-tomcat]]
* [[windows-upgrade-the-JRE]]
* [[windows-solutions-to-common-problems]]

**Linux**

* [[linux-system-requirements]]
* [[linux-launching-the-installer]]
* [[linux-installing-in-unattended-mode]]
* [[changing-the-user-account-lucee-runs-as]]
* [[linux-upgrade-the-JRE]]
* [[linux-installation-on-centos-linux]]

### Lucee Server Administration ###

**Windows**

* [[windows-start-stop-lucee]]
* [[windows-adding-new-sites]]
* [[windows-update-memory-settings]]
* [[windows-utilizing-tomcat-built-in-web-server]]
* [[windows-updating-tomcat-server-xml-file]]
* [[windows-updating-uriworkermap-properties-file]]
* [[windows-implementing-log-rotation-with-log4j]]
* [[windows-configuring-SES-url-on-windows-os]]

**Linux**

* [[linux-starting-and-stopping-lucee]]
* [[configure-tomcat-to-listen-to-port-linux]]
* [[linux-adding-sites]]
* [[lucee-configuring-SES-url]]

**Lucee Security Best Practices**

The following sections are intended for system administrators who want to deploy Lucee, via the Lucee Installer, in a secure but easy-to-follow way. This documentation is not intended to guarantee foolproof security, but rather serve as a set of guidelines for common security-minded best practices. It is important for the reader to understand that no system, no matter how well protected, will ever be 100% guaranteed secure; however, by following these simple guidelines the reader can ensure that their systems will deter the vast majority of common intrusion techniques.

* [[preparing-your-server-linux]]
* [[using-the-lucee-installer]]
* [[locking-down-your-lucee-stack]]
* [[locking-down-lucee-server]]
* [[credits-and-contributors]]

### Contribute ###

* [[meet-the-developers]]
* [[how-to-report-problems-or-suggest-features]]
