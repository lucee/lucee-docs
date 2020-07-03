---
title: Virtual File Systems
id: virtual-file-system
related:
- function-getvfsmetadata
categories:
- system
description: 'Lucee support the following virtual file systems: ram, file, s3, http,
  https, zip and tar'
---

## Virtual File Systems ##

Lucee supports the following virtual file systems: 

- ram 
- file 
- s3 
- http / https 
- zip 
- tar

### Local File System ###

You may already be familiar with local file systems, the local file system is the default file system in Lucee. 
That means if there is no other definition, Lucee will always use the local file system.

A simple example

```lucee
<cfscript>
	sct.file=getCurrenttemplatepath();
	sct.directory=getDirectoryFromPath(sct.file);
	dump(sct);

	dump(fileRead(sct.file));
	dump(directoryList(sct.directory));
</cfscript>
```

* [[function-getcurrenttemplatepath]] returns current template path,
* [[function-getDirectoryFromPath]] returns directory,
* pass the file path to the [[function-fileRead]], to read the content of the file,
* pass the directory to [[function-directoryList]] to list all the directories in the given folder path.

However, you can explicitly define the file system you want to use. To use a local file system, use the "//file" prefix.

As seen in the example code above, the local file system is the default, so it is not necessary to explicitly define it. The example below shows how you can explicitly define a local file system. The result is the same as the code above.

```lucee
<cfscript>
sct.file=getCurrenttemplatepath();
sct.directory=getDirectoryFromPath(sct.file);
dump(sct);

sct.file="file://"&sct.file;
sct.directory="file://"&sct.directory;

dump(fileRead(sct.file));
dump(directoryList(sct.directory));
</cfscript>
```

### ZIP File System ###

Another file system you can use in Lucee is the ZIP file system.
To tell Lucee to use the ZIP file system, use the prefix "zip://" and end with !
Now the file path will look like zip://xxx/xxx/xxx/xxx/testbox-2.2.0.zip!

A detailed example is provided below:

```lucee
<cfscript>
sct.file=getCurrenttemplatepath();
sct.directory=getDirectoryFromPath(sct.file);
dump(sct);

sct.zipFile=sct.directory&"testbox-2.2.0.zip";
sct.zip="Zip://"&sct.zipFile&"!"

dump(directoryList(sct.zip));
dump(directoryList(sct.zip&"/testbox"));
echo("<pre>");echo(fileRead(sct.zip&"/testbox/readme.md"));echo("</pre>")
</cfscript>
```

### http/https File System ###

Lucee also support the HTTP file system. Simply use the HTTP URL like you would use a file system definition.

The below example shows how to read the file content from the Lucee docs:

```lucee
<cfscript>
	uri="https://docs.lucee.org/reference/functions/abs.html";
	dump(fileRead(uri));
	dump(directoryList("https://lucee.org/index.cfm"));
</cfscript>
```

### RAM File System ###

RAM is an in Memory Filesystem that stores Files in the Memory of the Java Virtual Machine (JVM) simply by using "ram://",
unless you define a Cache in the Lucee Administrator for this Resource. 

The RAM file system has much faster access than a local file system.

Each Web Context has it's own independant RAM Cache, it cannot be shared between multiple contexts..

```lucee
<cfscript>
sct.ram = "ram://";
dump(sct);
dump(directoryCreate(sct.ram&"/heidi/"));
fileWrite(sct.ram&"susi.txt", "sorglos");
dump(directoryList(sct.ram));
</cfscript>
```

### S3 File System ###

S3 is a remote file system you can use from Amazon S3 storage. You will need access credentials for accessing the S3 bucket. 

Set up the S3 file system using the prefix "s3://"

In Lucee, we can define an S3 file system in two ways:

* Define credentials in the Application.cfc file
* Pass the credentials with the S3 URL

```lucee
<cfscript>
//In Application.cfc
this.s3.accesskeyid= "xxxxxxx"
this.s3.awssecretkey= "xxxxxxx"

sct.s3 = s3://#request.s3.accesskeyid#:#request.s3.awssecretkey#; // simply as file path
sct.s3 = "s3:///"; //If you define in cfc use like this

dir = directoryList(sct.s3);
dump(dir);

dir = directoryList(sct.s3&"testcasesS3/");
dump(dir);

dir = directoryList(sct.s3&"testcasesS3/a");
dump(dir);

c = fileRead(sct.s3&"testcasesS3/a/foo.txt");
dump(c);
</cfscript>
```

### FTP File System ###

 Lucee allows you to treat a remote FTP server as a virtual filesystem.

 You will need access credentials for accessing FTP. Set up an FTP file system using the prefix "ftp://"

```lucee
<cfscript>
/* How to configure default FTP settings via Application.cfc */ 
this.ftp.username="..."; 
this.ftp.password="..."; 
this.ftp.host="ftp.lucee.org"; 
this.ftp.port=21;

/* index.cfm */
ftp = ftp://#request.ftp.user#:#request.ftp.pass#@ftp53.world4you.com:21/;
//ftp="ftp:///"; // take credentials and host/port from Application.cfc
//ftp="ftp://ftp53.world4you.com:21/"; // take credentials from Application.cfc
//ftp="ftp://#request.ftp.user#:#request.ftp.pass#@/"; // take host/port from Application.cfc

dir = directoryList(ftp);
dump(dir);

</cfscript>
```

### Footnotes ###

Here you can see above details in video

[Lucee virtual File System](https://www.youtube.com/watch?time_continue=693&v=AzUNVYrbWiQ)
