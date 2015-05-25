---
id: getting-started
title: Getting Started
---

The easiest way to get started with Lucee is by using Ortus Solutions' [CommandBox](http://www.ortussolutions.com/products/commandbox). CommandBox comes with an embedded Lucee server so you can be up and running in just minutes.

## 1. Install Commandbox

You will need to install version 2.0.0 or later of CommandBox. Follow the instructions for your operating system here: [http://ortus.gitbooks.io/commandbox-documentation/content/setup/installation.html](http://ortus.gitbooks.io/commandbox-documentation/content/setup/installation.html).

>>> At the time of writing, version 2.0.0 of CommandBox is in beta. You can browse and download the binaries from [http://integration.stg.ortussolutions.com/artifacts/ortussolutions/commandbox/2.0.0/](http://integration.stg.ortussolutions.com/artifacts/ortussolutions/commandbox/2.0.0/).

## 2. Start up a Lucee server through CommandBox

Open up a terminal (Mac/Linux) or command prompt (Windows) and `cd` to an empty directory (create one for testing if necessary).

Type the following command at the command prompt:

```
/my/test/dir> box server start
```

The Lucee server will then start on a random port and open in your default browser and show a directory listing for the directory in which you started it, which is currently empty.

>>>>>> You can find out more about CommandBox's embedded server, and the `server start` command, here: [http://ortus.gitbooks.io/commandbox-documentation/content/embedded_server/embedded_server.html](http://ortus.gitbooks.io/commandbox-documentation/content/embedded_server/embedded_server.html)

## 3. "Hello world" index.cfm

Create an `index.cfm` file in the root of your directory with the following code:

```lucee
<cfset testVar = "Hello World">
<cfoutput>
	<h1>#testVar#</h1>
</cfoutput>
```

Refresh the browser window. Your browser should display the index page you just created and output "Hello World" in the browsers default H1 styling.

---

There you go, you just used the Lucee application server to run a CFML script that set a variable and then output that variable. Lucee is feature rich so you can do far more than this simple "hello world" script shows, so start having fun with Lucee today.