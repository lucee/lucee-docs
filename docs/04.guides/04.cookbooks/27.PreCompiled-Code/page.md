---
title: Precompiled
id: precompiled-code
---
## Precompiled Code ##

This document explains how to pre-compile code for a production server while the source code is deployed. This method avoids compilation on the production server for security reasons. We explain this method with a simple example below:

Example:

```lucee
//index.cfm page in current instance location like \webapps\ROOT\sample\index.cfm

Time is <cfscript>
writeoutput(now());
</cfscript>
```

Run this index.cfm page in the browser.

* Each time a cfm file is executed in Lucee, a class file is automatically created in the webroot --> WEBINFO --> lucee --> cfClasses folder. So, a class file(Ex: index_cfm$cf.class ) is usually created for your index.cfm file(Ex : index.cfm) in the cfClasses folder.

* Copy the class file and paste it into your current folder(\webapps\ROOT\sample). Then rename the class file to cfm file(test.cfm).

* If we open that test.cfm, it is a binary format file.

* Finally, run the test.cfm file in your browser. It should work as same way as the index.cfm file.

### Footnotes ###

Here you can see above details in video

[Lucee Precompiled Code](https://www.youtube.com/watch?v=Yjy3bQJgphA)
