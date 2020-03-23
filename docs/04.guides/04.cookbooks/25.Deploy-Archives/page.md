---
title: Creating and deploying Lucee Archives (.lar files)
id: deploy-archives
---
## Deploy Archive ##

This document explains how to deploy an Application on a live server without using single CFML file. 

Simple example:

### Using CFC file ###

```lucee
//placed under outside root/component/org/lucee/examples/deploy/Test.cfc
<cfscript>
component test {
	function salve() {
		return "Hi There"
	}
}
</cfscript>
```
You will need to add a mapping for the above cfc, because it's not inside the Root folder

Create component mapping in **Archives & Resources -> Component**

create a mapping test.cfc as like below

```
name: mycfc
resource: **Full folder path**/component/
```

After creating the mapping, you need to create an archive file for the cfc.

* Go to the detail view of mycfc mapping page,
* Click the button **assign archive to mapping**.

Archive(lar file) created automatically and saved in WEB-INF\lucee\context\archives

Now you can see the archive path on mycfc mapping

### Using CFM file ###

Create a mapping for below CFM file,

```lucee
//placed under /ROOT/test/deploy/index.cfm
<cfscript>
test = new org.lucee.examples.deploy.Test();
dump(test.slave());
</cfscript>
```
```
name: /deploy
resource: ROOT/test/deploy/index.cfm
```
After creating mapping in the Administrator, you can create an Archive file by clicking **assign archive to mapping**

Now you can see the both lar files were in WEB-INF\lucee\context\archives folder.

* One is lucee\context\archives\xxx-deploy.lar file,
* another one is lucee\context\archives\xxx-mycfc.lar

Now you can place the archive files in your target server.

Copy the archive files (deploy.lar, mycfc.lar) and placed in target server /WEB-INF/lucee/deploy folder wait for a minute. It successfully deploy your archives into the server.

You can now view mappings in admin.

### Footnotes ###

Here you can see above details in video

[Lucee Deploy Archive file](https://www.youtube.com/watch?time_continue=473&v=E9Z0KvspBAY)

