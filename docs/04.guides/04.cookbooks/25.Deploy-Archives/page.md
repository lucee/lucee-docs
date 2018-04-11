---
title: Deploy Archives
id: deploy-archives
---
## Deploy Archive ##

This document explains how to deploy the application in live server without using single CFML file. Explained with simple example

Example:

### Using CFC file ###

```lucee
//placed under outside the root anyfolder/component/org/lucee/examples/deploy/Test.cfc
<cfscript>
component test {
	function salve() {
		return "Hi There"
	}
}
</cfscript>
```
For cfc we should create a mapping because it's not within the root.

Create component mapping in **Archives & Resources -> Component**

create a mapping for the above test.cfc

```
name: mycfc
resource: **Full folder path**/component/
```

After creating that we need to create a archive file for the cfc.
* Go to the detail view of mycfc,
* Click the button "assign archive to mapping"

Archive created atomically and placed in WEB-INF\lucee\context\archives

Now you can see the archive path on mycfc mapping

### Using CFM file ###
name: /deploy
resource: ROOT/test/deploy/index.cfm

```lucee
//placed under /ROOT/test/deploy/index.cfm
<cfscript>
test = new org.lucee.examples.deploy.Test();
dump(test.slave());
</cfscript>
```
Same as we can create a mapping for deploy folder & create archive for deploy folder also like above.

After creating archive file delete /deploy & mycfc the mapping & their folders

Now you can place the archive files in your target server.

Copy the archive file and placed in target server /WEB-INF/lucee/deploy folder wait for a minute. It successfully deploy your archives into server. You can now view mappings in admin area now.

### Footnotes ###

Here you can see above details in video

[Lucee Deploy Archive file ](https://www.youtube.com/watch?time_continue=473&v=E9Z0KvspBAY)

