---
title: Lucee Step Debugger Installation Guide
id: lucee-step-debugger-installation-guide
categories:
- debugging
description: How to set up the step debugger "luceedebug" for enhanced CFML Debugging in Visual Studio Code and Lucee
---

## Lucee Step Debugger Installation Guide

### 1. Introduction

**luceedebug** is a step-by-step CFML Lucee debugger created by David Rogers for developing CFML with Visual Studio Code running on the Lucee CFML engine. It allows using breakpoints, conditional breakpoints, watchers, and dumps by mousing over variables of your CFML code, enhancing your coding experience with CFML.

This documentation shows an easy working example of setting up **luceedebug** for Visual Studio Code on a Windows machine. For the sake of simplicity, we will use a **Lucee Express 5.4 LTS** version as a starting point and setup all the needed components within a directory named `D:\luceedebug_example\` on a Windows OS but will show also an alternative for Linux/MacOs in a directory named `\opt\luceedebug_example\`. For testing the debuger we will use Lucee's default Application shipped within the Lucee Express Version. Please consider adapting this example to your specific needs of your own cfml development environment.

For more detailed information about Luceedebug or contributing to this awesome open-source tool, please visit [https://github.com/softwareCobbler/luceedebug](https://github.com/softwareCobbler/luceedebug).

### 2. What we need

To set up **luceedebug** and make it available in Visual Studio Code you'll need the following components: 

- A **Lucee CFML-Engine** to run your CFML code: For this example, we'll use the Lucee Express Version 5.4 LTS.
- A **Java JDK**: We will use JAVA 11 LTS as the Java Development Kit (JDK). A JDK is a *MUST have*: Using just a Java Runtime Environment (JRE) won't suffice to run luceedebug!
- **luceedebug.jar (Debugger-Server)**: this is the server-side backend of the Lucee-Debugger that runs as a Java agent in Tomcat: While Tomcat runs the Lucee CFML Engine on the default port 8888, the Java Agent also runs in parallel providing all the necessary information for the Visual Studio Code Luceedebug Extension (Debugger-Client). That Java Agent provides this service on an additional port.
- **Visual Studio Code Luceedebug Extension (Debugger-Client):** This is the Visual Studio Code client installed as a Visual Studio Code extension through the Visual Studio Code Extension Marketplace. When installed, this client connects from your Visual Studio Code to request the Luceedebug running server-side backend. It will also be listening for any information coming from the server side luceedebug.
- **A code base to debug**: As an example, we will use Lucee's default application shipped with the Lucee Express Version 5.4 LTS at `Lucee-Installation-Path\webapps\ROOT\`.

As a quick overview: At the end of the installation process shown in this documentation, the file tree should look somehow like the one shown below (this file tree only shows the relevant file structure):

```
luceedebug_example
 +-java
 |  +-jdk-11.0.23+9 (Java 11 JDK LTS)
 |
 +-lucee-express-5.4.6.9 (Lucee Engine)
 |  +-bin
 |  |  +-startup.bat (used to start Tomcat on Windows)
 |  |  +-startup.sh (used to start Tomcat on Linux/MacOs)
 |  |  +-setenv.bat (Tomcat configuration file for launching Lucee with the luceedebug.jar as Java Agent)
 |  |  +-setenv.sh (Tomcat configuration file for launching Lucee with the luceedebug.jar as Java Agent)
 |  +-webapps
 |     +-ROOT
 |        +-index.cfm (file to try to debug)
 |
 +-luceedebug
 |  +-luceedebug.jar (Luceedebug Java files for the debugger server endpoint)
 |
 +-lucee_debug_example.code-workspace (VSCode workspace configuration file)
```

### 3. The Seven Steps to Install, Setup and Configure Luceedebug

#### Step 1: Download Lucee Express 5.4 LTS

 1. Create a directory as a container to hold all the files necessary for this example e.g. named `D:\luceedebug_example\`. 
 2. Download [Lucee Express 5.4.6.9 LTS](https://cdn.lucee.org/lucee-express-5.4.6.9.zip) and extract the zip file to `D:\luceedebug_example\lucee-express-5.4.6.9\`.

#### Step 2: Download JAVA 11 JDK LTS

 1. Create a directory to hold your JAVA JDK artifact e.g. named `D:\luceedebug_example\java\`. 
 2. Get the latest JAVA 11 JDK of your development environment at [Adoptium](https://adoptium.net/de/temurin/releases/?version=11&package=jdk&arch=x64). In this example, we'll be using the JAVA 11 JDK Version `Java jdk-11.0.23+9`. Extract the downloaded JDK to `D:\luceedebug_example\java\jdk-11.0.23+9\`.

#### Step 3: Download luceedebug.jar

 1. Create a directory to hold your luceedebug artifact e.g. named `D:\luceedebug_example\luceedebug\`. 
 2. Get the latest `luceedebug.jar` at David Rogers' GitHub page at [https://github.com/softwareCobbler/luceedebug/releases/latest](https://github.com/softwareCobbler/luceedebug/releases/latest). Place the jar file in `D:\luceedebug_example\luceedebug\luceedebug.jar`.

#### Step 4: Setup Tomcat/Lucee to run luceedebug.jar as the JAVA Agent

For Windows: Create a file at `D:\luceedebug_example\lucee-express-5.4.6.9\bin\setenv.bat` with the following content:

```bat
REM set MY_HOME as the main directory 
set "MY_HOME=../../"

REM set paths to luceedebug 
set "LUCEEDEBUG_JAR=%MY_HOME%luceedebug/luceedebug.jar"

REM set a path to a dedicated JDK 
set "JAVA_HOME=%MY_HOME%java\jdk-11.0.23+9\"
set "JRE_HOME=%JAVA_HOME%"
set "PATH=%JAVA_HOME%\bin;%PATH%"

REM run Tomcat with Lucee and LuceeDebug as the Java Agent. While Lucee runs on default on localhost:8888, the Lucee Server Side Debug (JAVA AGENT) runs on localhost:9999. The VSCode Extension Clients Listening Port is set to 10000. 
set "CATALINA_OPTS=%CATALINA_OPTS% -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=localhost:9999 -javaagent:%LUCEEDEBUG_JAR%=jdwpHost=localhost,jdwpPort=9999,debugHost=0.0.0.0,debugPort=10000,jarPath=%LUCEEDEBUG_JAR%"

exit /b 0
```

Then try running the file `D:\luceedebug_example\lucee-express-5.4.6.9\bin\startup.bat` on your Windows machine. 

For Linux/MacOs: Create a file at `\opt\luceedebug_example\lucee-express-5.4.6.9\bin\setenv.bat` with the following content:

```bash
#!/bin/bash

export MY_HOME="../../"

# Set paths to luceedebug 
# export LUCEEDEBUG_JAR="${MY_HOME}luceedebug/luceedebug.jar"

# Set JAVA_HOME for JDK 11 on Windows D: drive
export JAVA_HOME="${MY_HOME}java/jdk-11.0.23+9"

# Set JRE_HOME
export JRE_HOME="${JAVA_HOME}"

# run Tomcat with Lucee and LuceeDebug as the Java Agent. While Lucee runs on default on localhost:8888, the Lucee Server Side Debug (JAVA AGENT) runs on localhost:9999. The VSCode Extension Clients Listening Port is set to 10000.
export CATALINA_OPTS="${CATALINA_OPTS} -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=localhost:9999 -javaagent:${LUCEEDEBUG_JAR}=jdwpHost=localhost,jdwpPort=9999,debugHost=0.0.0.0,debugPort=10000,jarPath=${LUCEEDEBUG_JAR}"
```

Then try running the file `/opt/luceedebug_example/lucee-express-5.4.6.9/bin/startup.sv` on your Linux/MacOs machine. 

The steps above will start a Tomcat instance running Lucee as your CFML engine at `http://localhost:8888` while the Java Agent "Luceedebug" service will be listening at `localhost:9999`. Also, the luceedebug running on the server will send data to the Visual Studio Code Luceedebug Extension on port 10000 (e.g. when a breakpoint is reached during runtime).

#### Step 5: Install the Lucee-Debug Visual Studio Code Extension to your Visual Studio Code

Get the `Luceedebug Visual Studio Code Extension` by installing the extension from [https://marketplace.visualstudio.com/items?itemName=DavidRogers.luceedebug](https://marketplace.visualstudio.com/items?itemName=DavidRogers.luceedebug) or install it by searching the Marketplace repository from within your Visual Studio Code with `Ctrl+Shift+X` and searching for `Luceedebug`. Install the extension by clicking `install`. You may need to restart Visual Studio Code.

#### Step 6: Configure Your Workspace to Launch the Visual Studio Code Luceedebug Extension

At this moment, Lucee is already running providing your CFML generated content at `http://localhost:8888`, and the **Luceedebug.jar** is listening at localhost:9999, but the Visual Studio Code Editor doesn't know about it yet. The last step is to link the code base at `D:\luceedebug_example\lucee-express-5.4.6.9/webapps/ROOT` to the Visual Studio Code Luceedebug Extension and configure it to use the remote endpoint at localhost:9999 (Luceedebug.jar). This can typically be done within the workspace setting file. To achieve that, create a file named `lucee_debug_example.code-workspace` at `D:\luceedebug_example\lucee_debug_example.code-workspace` with the following content:

## Configuration for Lucee Debugging

### On Windows:

```
{
  "folders": [
    {
      "path": "D:\\luceedebug_example\\lucee-express-5.4.6.9\\webapps\\ROOT"
    }
  ],
  "launch": {
    "version": "0.2.0",
    "configurations": [
      {
        "type": "cfml",
        "request": "attach",
        "name": "Attach to Lucee Debug Backend",
        "hostName": "localhost",
        "port": 10000,
        "pathTransforms": []
      }
    ]
  },
  "settings": {
    "files.exclude": {
      "**/WEB-INF": true
    }
  }
}
```

### On Linux/MacOs:

```
{
  "folders": [
    {
      "path": "/opt/luceedebug_example/lucee-express-5.4.6.9/webapps/ROOT"
    }
  ],
  "launch": {
    "version": "0.2.0",
    "configurations": [
      {
        "type": "cfml",
        "request": "attach",
        "name": "Attach to Lucee Debug Backend",
        "hostName": "localhost",
        "port": 10000,
        "pathTransforms": []
      }
    ]
  },
  "settings": {
    "files.exclude": {
      "**/WEB-INF": true
    }
  }
}
```

#### Step 7: Running everything all together

While the Tomcat Lucee instance is already running at `http://localhost:8888` (test it by browsing to it) and the Java Agent with luceedebug.jar is listening on localhost:9999, you can open the workspace by double-clicking the file at `D:\luceedebug_example\lucee_debug_example.code-workspace`. This should open your Visual Studio Code with Lucee's default application at `D:\luceedebug_example\lucee-express-5.4.6.9\webapps\ROOT\index.cfm`. 

Open that file within your Visual Studio Code for editing. Click the `Debug-Icon` in the navigation pane or press `SHIFT+CTRL+D`: this will start the Visual Studio Code Debugging Mode with all debugging panes populated by the Visual Studio Code Lucee Debug Extension. 

To start debugging just add a breakpoint somewhere in the code of index.cfm by right-clicking on the left side of a row number (e.g. index.cfm line 10). To start debugging: click on "Attach to Luceedebug Backend" in the top views or press F5 or go to the top menu und click on "Run" => "Start Debugging". Now load the page in your browser at `http://localhost:8888`. When the breakpoint is reached, Visual Studio Code will prompt you with all information gathered in the debugging views. Enjoy!

### 4. Binding Luceedebug to a Webroot Outside Your VSCode Workplace With "pathTransforms"-Directive

By default Luceedebug associates the folder set in your workplace as being also the directory deployed to the Lucee engine. In the simple example described above it's set to `D:\luceedebug_example\lucee-express-5.4.6.9\webapps\ROOT`.

However, there are many times the CFML code base you are working locally witin your VSCode workplace won't match the directory served by Lucee: Imagine you are working locally on your CFML files, but you are deploying the files directly "onSave" via SSH or sFTP to a remote Lucee Development Server fully outside your VsCode Workplace. In this special cases you'll need to translate/adjust those remote paths used by Lucee to match the ones used by your Visual Studio Code workplace. Another example would be when using Docker-Container, when Lucee runs the cfml files internally with a different directory path. This is when the "pathTransforms"-directive might help you. 

In the following example we will configure Lucee to run cfml code outside your workplace and use `pathTransforms` to override the extensions default behaviour.

#### Step 1: Create a Directory To Hold Your Deployed CFML files

Create a directory named `mywebroot` at `D:\luceedebug_example\mywebroot\` and copy all your code base to that location to simulate a remote directory that differs from your workspace.

#### Step 2: Configure Lucee To Serve Files From `D:\luceedebug_example\mywebroot\`

Create a file named `ROOT.xml` at `D:\luceedebug_example\lucee-express-5.4.6.9\conf\Catalina\localhost\ROOT.xml` with the following content:

On Windows:

```xml
<Context 
  docBase="D:/luceedebug_example/mywebroot" 
  path="" 
  reloadable="true" 
/>
```

On Linux/MacOs:

```xml
<Context 
  docBase="/opt/luceedebug_example/mywebroot" 
  path="" 
  reloadable="true" 
/>
```

Then restart Lucee to the changes to take effect.

#### Step 3: Configure Visual Studio Code Luceedebug Extension To Override Paths With pathTransforms-directive

Edit your workplace setting file located at `D:\luceedebug_example\lucee_debug_example.code-workspace` and add the pathTransforms directive with `idePrefix` and `serverPrefix`  to match the settings:

On Windows:

```json
{
	"folders": [
		{
			"path": "D:\\luceedebug_example\\lucee-express-5.4.6.9\\webapps\\ROOT"
		}
	],
	"launch": {
		"version": "0.2.0",
		"configurations": [
			{
				"type": "cfml",
				"request": "attach",
				"name": "Attach to Luceedebug Backend",
				"hostName": "localhost",
				"port": 10000,
				 "pathTransforms": [
					{
						"idePrefix": "D:\\luceedebug_example\\lucee-express-5.4.6.9\\webapps\\ROOT",
						"serverPrefix": "D:\\luceedebug_example\\mywebroot"
					}
				]
			}
		]
	},
	"settings": {
		"files.exclude": {
			"**/WEB-INF": true
		}
	}
}
```

On Linux/MacOs:

```json
{
	"folders": [
		{
			"path": "/opt/luceedebug_example/lucee-express-5.4.6.9/webapps/ROOT"
		}
	],
	"launch": {
		"version": "0.2.0",
		"configurations": [
			{
				"type": "cfml",
				"request": "attach",
				"name": "Attach to Luceedebug Backend",
				"hostName": "localhost",
				"port": 10000,
				 "pathTransforms": [
					{
						"idePrefix": "/opt/luceedebug_example/lucee-express-5.4.6.9/webapps/ROOT",
						"serverPrefix": "/opt/luceedebug_example/mywebroot"
					}
				]
			}
		]
	},
	"settings": {
		"files.exclude": {
			"**/WEB-INF": true
		}
	}
}
```

Then restart Lucee to the changes to take effect. Reopen your VsCode for the extension to pick up the new settings and try setting breakpoints.

### 5. Verifying the pathTransforms and breakpoint bindings

If breakpoints aren't binding or pathTransforms directives are not being honoured, you can inspect what's going on using the "luceedebug: show class and breakpoint info" command. Surface this by typing "show class and breakpoint info" into the [command palette](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette).

For further detailed information please visit [https://github.com/softwareCobbler/luceedebug](https://github.com/softwareCobbler/luceedebug).
