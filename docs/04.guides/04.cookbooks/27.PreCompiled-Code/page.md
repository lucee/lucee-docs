---
title: Precompiled
id: precompiled-code
---
## Precompiled Code ##

This document explains how to pre_compiling in production server while deployed the source code. It avoid the compilation on production server for security reason. Explained with simple example

Example:

```lucee
//index.cfm page in current instance location like \webapps\ROOT\sample\index.cfm

Time is <cfscript>
writeoutput(now());
</cfscript>
```
Once run this index.cfm page in browser.

* In every time execute a cfm file in lucee, It automatically created a class file in webroot --> WEBINFO --> lucee --> cfClasses folder. So as usually created a class file(Ex: index_cfm$cf.class ) for your index.cfm file(Ex : index.cfm) in cfClasses folder. 

* Copy those class file & paste it into your current folder(\webapps\ROOT\sample\) and then rename the class file into cfm file(test.cfm). 

* If we just open that test.cfm means it looks like binary format file.

* Finally, Run the test.cfm page to browser. It working as same as index.cfm page.

### Footnotes ###

Here you can see above details in video

[Lucee Precompiled Code ](https://www.youtube.com/watch?v=Yjy3bQJgphA)