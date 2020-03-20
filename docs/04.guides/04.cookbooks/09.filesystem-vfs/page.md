---
title: Virtual File Systems (ram, ftp, zip, s3, etc...)
id: cookbook-filesystem-vfs
menuTitle: Virtual File Systems
---

# Virtual Filesystems #
A closer look on all virtual Filesystems supported by Lucee.

## RAM ##
RAM is an in Memory Filesystem that stores Files in the Memory of the Java Vitual Machine (JVM), unless you attach a Cache in the Lucee Administrator for this Resource.
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

## FTP ##
FTP allows you to use a FTP server as a virtual filesystem. You can define the credentials to connect the FTP Server as part of the path itself or in the Application.cfc (Lucee 5.3 and above).

### Example Code: ###

```cfs
/* Application.cfc */
	this.ftp.username="...";
	this.ftp.password="...";
	this.ftp.host="ftp.lucee.org";
	this.ftp.port=21;

/* index.cfm */
ftp="ftp://#request.ftp.user#:#request.ftp.pass#@ftp53.world4you.com:21/"; // add credentials to path
//ftp="ftp:///"; // take credentials and host/port from Application.cfc
//ftp="ftp://ftp53.world4you.com:21/"; // take credentials from Application.cfc
//ftp="ftp://#request.ftp.user#:#request.ftp.pass#@/"; // take host/port from Application.cfc

dump(directoryList(ftp));

```

## ZIP ##
ZIP allows you to use a ZIP File as a Filesystem, you can read files and folders from a zip and also manipulate it's content.

### Example Code: ###

```cfs
sct.file=getCurrentTemplatePath();
sct.directory=getDirectoryFromPath(sct.file);
sct.zipFile=sct.directory&"my.zip";
sct.zip="zip://"&sct.zipFile&"!";
dump(sct);
dump(directoryList(sct.zip));
dump(directoryList(sct.zip&"/myfolder"));
echo("<pre>");echo(fileRead(sct.zip&"/myfolder/my.txt"));echo("</pre>");

```

## S3 ##
S3 allows you to use S3, the Cloud Storage Service from Amazon to use a virtual Filesystem.

### Example Code: ###

```cfs
/* Application.cfc */
	this.s3.accessKeyId = "...";
	this.s3.awsSecretKey = "...";

/* index.cfm */
sct.s3 = "s3://#request.s3.accessKeyId#:#request.s3.awsSecretKey#@/"; // add credentials to path
sct.s3 = "s3:///"; // take credentials from Application.cfc
dump(sct);
dir=directoryList(sct.s3);
dump(dir);
```

## HTTP ##
HTTP allows you to use HTTP URLs as a virtual Filesystem. This is limited to read operation, because in most cases Webserver do not allow methods PUT,DELETE,UPDATE.

### Example Code: ###

```cfs
sct.uri="https://docs.lucee.org/reference/functions/abs.html";
dump(sct);
dump(fileRead(sct.uri));
dump(directoryList("https://lucee.org/index.cfm"));
```
