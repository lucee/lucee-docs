---
title: Installing Tomcat and Lucee on Mac OS X using the Lucee WAR file
id: running-lucee-installing-tomcat-and-lucee-on-os-x-using-the-lucee-war-file
---

This guide walks you through deploying Lucee as a WAR file to Apache Tomcat on macOS. This is a lightweight setup ideal for development or small deployments where you want full control over your servlet container.

By the end of this guide, you'll have Lucee running at `http://localhost:8080/` with access to both the Server and Web admin interfaces.

## Prerequisites

- **Java 11 or higher** - Lucee 6.x requires Java 11+. You can install via Homebrew: `brew install openjdk@21`
- **Apache Tomcat** - Version depends on your Lucee version:
  - **Lucee 6.x** (javax-based): Use [Tomcat 9.x](https://tomcat.apache.org/download-90.cgi)
  - **Lucee 7+** (jakarta-based): Use [Tomcat 10.x](https://tomcat.apache.org/download-10.cgi) or [11.x](https://tomcat.apache.org/download-11.cgi)

## Installation Steps

1. Extract Tomcat to your home folder `/Users/<username>/`. For convenience, rename the folder to `tomcat`.

1. Go into `tomcat/webapps/`. Delete the `/ROOT/` folder and `/ROOT.war/`.

1. Go to the [Lucee download page](https://download.lucee.org/) and download the latest Lucee WAR file.

1. Rename the Lucee WAR file to `ROOT.war` (note the capitalization).

1. Copy `ROOT.war` into `tomcat/webapps/`.

1. Create a `startup.sh` file in the `tomcat/` directory with the following contents, replacing `<username>` with your macOS username:

```bash
#!/bin/bash
# set the path to Tomcat binaries
export CATALINA_HOME=/Users/<username>/tomcat

# set the path to the instance config
export CATALINA_BASE=/Users/<username>/tomcat

EXECUTABLE=${CATALINA_HOME}/bin/catalina.sh
exec $EXECUTABLE run
```

1. Make the script executable and start Tomcat:

```bash
chmod +x startup.sh
./startup.sh
```

1. Open a web browser to `http://localhost:8080/lucee/admin/server.cfm`. You should see the Lucee Server Admin login screen. On first access, you'll be prompted to set an admin password.

## Understanding Lucee's Directory Structure

When Lucee starts, it creates configuration directories:

- **Server config**: `tomcat/webapps/ROOT/WEB-INF/lucee-server/` - Contains server-wide settings
- **Web config**: `tomcat/webapps/ROOT/WEB-INF/lucee/` - Contains web context settings
- **Config file**: `.CFConfig.json` in the `context/` subdirectory stores your configuration

## Optional: Apache Integration

You may want to install [mod_cfml](https://viviotech.github.io/mod_cfml/) to integrate with the Apache web server.

## Next Steps

From this point you can configure your Tomcat instance and set up your applications in Lucee.
