---
title: Virtual FileSystems
id: virtual-file-system
---
## Virtual FileSystems ##

This document explains virtual file systems in lucee

### Local File System ###

You may already be familiar with local file systems.

### Example ###
Simple example shown below

```lucee
<cfscript>
	sct.file=getCurrenttemplatepath();
	sct.directory=getDirectoryFromPath(sct.file);
	dump(sct);

	dump(fileRead(sct.file));
	dump(directoryList(sct.directory));
</cfscript>
```

* getCurrenttemplatepath() returns current template path,
* getDirectoryFromPath() returns directory,
* pass the file path to the fileRead(), to read the content of the file,
* pass the directory to directoryList(), to list all the directories in the given folder path.

The local file system is the default file system in Lucee. That means if there is no other definition, Lucee will always use the local file system.

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

### Http File System ###

Lucee also handles the HTTP file system. Simply use the HTTP URL like you would use a file system definition.

The below example shows how to read the file content from the Lucee docs:

```lucee
<cfscript>
	sct.uri="http://docs.lucee.org/reference/functions/abs.html";
	dump(fileRead(sct.uri));
</cfscript>
```


### Ram File System ###

The RAM file system is a memory file system allowing you to store files in memory by simply using "ram://". The RAM file system has much faster access than a local file system.

```lucee
<cfscript>
sct.ram = "ram://";
dump(sct);
dump(directoryCreate(sct.ram&"/heidi/"));
fileWrite(sct.ram&"susi.txt", "sorglos");
dump(directoryList(sct.ram));
</cfscript>
```

Important point to know: the RAM resource is independent to each context. It cannot be shared with multiple contexts.

### S3 File System ###

S3 is a remote file system you can use from Amazon S3 storage. You will need access credentials for accessing the S3 bucket. Set up the S3 file system using the prefix "s3://"

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

FTP is a remote file system. You will need access credentials for accessing FTP. Set up an FTP file system using the prefix "ftp://"


```lucee
<cfscript>
sct.ftp = ftp://#request.ftp.user#:#request.ftp.pass#@ftp53.world4you.com:21/;

dir = directoryList(sct.ftp);
dump(dir);

</cfscript>
```
### Footnotes ###

Here you can see above details in video

[Lucee virtual File System](https://www.youtube.com/watch?time_continue=693&v=AzUNVYrbWiQ)