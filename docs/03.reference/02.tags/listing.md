---
title: Tags
id: tags
listingStyle: a-z
menuTitle: Tags
---

Tags are at the core of Lucee Server's templating language. 

CFML Tags can also be called via [[tag-script]]. Usually you don't even need the CF prefix, but you need it in some cases when there is an existing function with the same name. You can also omit () when using the script syntax for tags.

```luceescript
cflog(text="I called a tag from script);  // use cflog, because there is already a maths [[function-log]] function


cfhttp(url="https://docs.lucee.org");
http url="https://docs.lucee.org";


cflocation(url="https://dev.lucee.org");
location url="https://dev.lucee.org";
```

You can also assign default values for any tag's attributes using *this.tag.tagname.attribute* in Application.cfc.

```luceescript
this.tag.cfhttp.username = "system";
this.tag.cflog.logfile = "my-custom-log.log";
this.tag.cflocation.addtoken = false;
```
