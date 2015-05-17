---
id: getting-started
title: Getting Started
---

# Getting Started

It is easy to get started with Lucee using Ortus Solutions CommandBox. CommandBox comes with an embedded Lucee server so you can be up and running in just minutes.

1. [Download CommandBox](http://integration.stg.ortussolutions.com/artifacts/ortussolutions/commandbox/2.0.0/) available for Windows / Mac / Linux with and without the JRE.
2. [Install CommandBox](http://ortus.gitbooks.io/commandbox-documentation/content/setup/installation.html).
3. Go to a terminal (Mac/Linux) or command prompt (Windows).
4. Create an empty directory and go into that directory. This will be the directory in which your Lucee application files will be keep.
5. Type "box" to start up CommandBox. The first time you run CommandBox it will take slightly longer than normal as it has to initialize the configuration on your machine. 
6. Once you are at the CommandBox prompt type "server start" to start the embedded Lucee server within CommandBox. The Lucee server will then start, on a random port and open in your default browser and show a directory listing for the directory in which you started it, which is currently empty.
7. Next type ```touch index.cfm``` to create and index.cfm file in your directory.
8. Then type ```edit index.cfm``` to open the index.cfm file in your default text editor for ".cfm" files, if you don't have one assigned the operating system should ask you which editor to use. Once index.cfm is open in an editor add the following two lines to it and save it.

    ```<cfset testVar = "Hello World">```
    
    ```<h1><cfoutput>#testVar#</cfoutput></h1>```

9. Refresh the browser window and your browser should automatically display the index page you just created, displaying "Hello World" in the browsers default H1 styling.

There you go, you just used the Lucee application server to run a CFML script that set a variable and then output that variable. Lucee is feature rich so you can do far more than this simple "hello world" script shows, so start having fun with Lucee today.