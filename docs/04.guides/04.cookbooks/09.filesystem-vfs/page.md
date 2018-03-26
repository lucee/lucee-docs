---
title: Virtual File Systems (ram, ftp, zip, s3, etc...)
id: cookbook-filesystem-vfs
---

# Virtual Filesystems #
A closer look on all filesystem supported by Lucee.

## RAM ##
RAM is a in Memoy Filesystem that stores Files in the Memory of the Java Vitual Machine (JVM), unless you attach a Cache in the Lucee Administartor for this Resource.
Every Web-Context does have it's own RAM Cache.

### Example Code: ###

```cfs
sct.ram="ram://"
dump(sct);
dump(directoryList(sct.ram));
directoryCreate(sct.ram&"/heidi2/")
fileWrite(sct.ram&"/susi2.txt","Sorglos");
dump(directoryList(sct.ram))
```
