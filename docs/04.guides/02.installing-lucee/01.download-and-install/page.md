---
title: Download and Install
id: running-lucee-download-and-install
---

[Home](Home)

# Download and Install Lucee Server #

Lucee Server comes in different flavors to match your needs.

## Run without installation ##

"Lucee Express" allows you to test Lucee without installing it.
Simply download a zip, unzip that file and execute a batch file, that's all!
If you are done using that version, simply delete it and it is gone for good!

Download the latest "Express" version [here](https://lucee.org/downloads.html) and have fun!

By default the Express version listens on port 8888.

## Installers ##

We provide installers to install Lucee on your platform, bundled with the Tomcat Servlet Engine and the web server connectors necessary.
Simply download the installer for your platform [here](https://lucee.org/downloads.html).

## CommandBox ##

CommandBox comes with an embedded Lucee server so you can be up and running in just minutes. [[getting-started-commandbox]]

## Custom Installation ##

If you want to use Lucee in a different environment, e.g. with a different servlet engine, simply download our "Lucee Custom" package [here](https://lucee.org/downloads.html), it contains everything you need for this task.

## Using Lucee with multiple websites, mod_cfml ##

Lucee doesn't support multiple webserver hosts directly, however [mod_cfml](https://viviotech.github.io/mod_cfml/index.html) is available to achieve this.

## Java Versions Supported ##

- The Official Lucee Installer comes with Java 11, which is our recommended version
- Java 8 is still officially supported for 5.3, with Lucee 6 it will be no longer officially supported, but will be unofficially, as long as feasible
- Lucee Supports Java 9 since version 5.3.0.57
- Java 16 is not currently supported due to breaking internal changes with the jvm, [LDEV-3526](https://luceeserver.atlassian.net/browse/LDEV-3526)

### Java Support tips

- When reporting a bug with Lucee, **please always describe your stack** (Lucee version, Java Version, Tomcat/etc version and the Extension version, if it's extension related)
- If you aren't running the latest release of Java and encounter a problem, please try updating your Java version before reporting a bug, especially if it's several years old!
