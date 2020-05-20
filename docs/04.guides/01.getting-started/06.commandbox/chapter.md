---
id: getting-started-commandbox
title: CommandBox
---

The easiest way to get started with Lucee is by using Ortus Solutions' [CommandBox](https://www.ortussolutions.com/products/commandbox). CommandBox comes with an embedded Lucee server so you can be up and running in just minutes.

## 1. Install CommandBox

You will need to install version 2.0.0 or later of CommandBox. Follow the instructions for your operating system here: [https://commandbox.ortusbooks.com/getting-started-guide](https://commandbox.ortusbooks.com/getting-started-guide).

## 2. Start up a Lucee server through CommandBox

Open up a terminal (Mac/Linux) or command prompt (Windows) and `cd` to an empty directory (create one for testing if necessary).

Type the following command at the command prompt:

```
/my/test/dir> box server start
```

The Lucee server will then start on a random port and open in your default browser and show a directory listing for the directory in which you started it, which is currently empty.

>>>>>> You can find out more about CommandBox's embedded server, and the `server start` command, here: [https://commandbox.ortusbooks.com/embedded-server](https://commandbox.ortusbooks.com/embedded-server)

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
