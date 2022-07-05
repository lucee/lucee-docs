---
title: Installing Lucee on Windows
id: running-lucee-windows
menuTitle: Windows
---

## Introduction

There are a few different ways to get Lucee up and running on Windows

- you can [[running-lucee-download-and-install]] the traditional Installer. Watch this step by step video guide about [[running-lucee-installing-lucee-on-windows-2019-with-installer-quick-video-guide]]
- the Express version (which just runs out of a folder)
- [[getting-started-commandbox]] which provides an automated way to manage and deploy both Lucee and Adobe ColdFusion servers (it's sort of like Docker but a million times less complex)

## Content ##

Here are some in depth guides to setting up an environment to run Lucee on a Windows, you probably won't
need to delve into the following sections if you are using one of the above approaches as they automate most of this.

* [[running-lucee-installing-the-boncode-connector-and-mod_cfml]]
* [[running-lucee-installing-oracle-java-on-windows]]
* [[running-lucee-installing-apache-tomcat-on-windows]]
* [[running-lucee-installing-xampp-apache2-and-mariadb-on-windows]]
* [[running-lucee-configuring-tomcat-as-a-windows-service]]
* [[running-lucee-starting-tomcat-and-verifying-the-installation-on-windows]]
* [[running-lucee-installing-and-configuring-lucee-jar-file-on-windows]]
* [[running-lucee-securing-tomcat-and-lucee-on-windows]]
* [[running-lucee-optimizing-iis]]
* [[running-lucee-securing-iis]]
* [[running-lucee-scripts-installing-tomcat-and-lucee-on-windows]]
* [[running-lucee-installing-the-jdk-on-windows]]
* [[running-lucee-installing-the-server-jre-on-windows]]

## Check your ports ##

You will run into problems if some of the ports Lucee uses are already in use.

A default install of Lucee uses ports 8888, 8005 and 8009

You can easily check which ports are already in use

- using Powershell ```Get-NetTCPConnection | ? {$_.State -eq "Listen"} | sort LocalPort -Descending```
- via Resource Monitor, Network Tab, Listening Ports (Windows-R, type resmon)
- or thru Task Manager, Performance, open Resource Monitor.

## Prerequisites ##

* A Windows machine with Full administrator privileges
* Basic understanding of the Windows Registry, file system and user management
* Basic familiarity with the command line

## Automated Deployment ##

All of the tasks described in this guide can be integrated into a software management tool such *Microsoft SCCM*. Everything can be done on the command line, which is perfect for scripting and packaging.

- - -
This guide is a work in progress. Please be patient, more to come ;-)

*Author: Martin Schaible. Thanks to Julian Halliwell for the proof reading.*
