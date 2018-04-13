---
title: Virtual FileSystems
id: virtual-file-system
---
## Virtual FileSystems ##

This document explains Virtual Filesytem in lucee

### Local File System ###

You may familiar with local file system.

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

* getCurrenttemplatepath() return's current template path,
* getDirectoryFromPath() return's directory,
* pass the file path to the fileRead(), to read the content of the file,
* pass the directory to directoryList(), to list all the directories in the given folder path.

Local file system is default file system in lucee. That mean there is no other definitions always lucee use that file system.


But you can explict defined the file system you want to use in case of local system you do that with "//file" prefix.

lucee know you want to use the file system. For local file system is not necessary because it's default file system. Shown example below

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

Results same as above example.

### ZIP File System ###

Lucee use another file system is ZIP file system.

* For zip file system starts with prefix "zip://" because lucee has to know it has to use zip file system.
* Ends with ```!```.
* Now file path look's like zip://xxx/xxx/xxx/xxx/testbox-2.2.0.zip!

Detail example given below

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

Lucee handle HTTP file system, simply use HTTP URL use like a file system.

Given simple example to read the file content from the lucee docs

```lucee
<cfscript>
	sct.uri="http://docs.lucee.org/reference/functions/abs.html";
	dump(fileRead(sct.uri));
</cfscript>
```


### Ram File System ###

Ram File System is in a memory file system so you can store files in memory by simply use "ram://". Ram files is very faster access than local file system.

```lucee
<cfscript>
sct.ram = "ram://";
dump(sct);
dump(directoryCreate(sct.ram&"/heidi/"));
fileWrite(sct.ram&"susi.txt", "sorglos");
dump(directoryList(sct.ram));
</cfscript>
```


Important point to know, that the ram resource is independent to every context it can't able to share with multiple context.

### S3 File System ###

S3 is remote file you can use from amazon. You should have credentials for accessing s3 bucket. Use with prefix "s3://"

In lucee we can define it by two ways

* Define credentials in Application.cfc,
* Passed credentials with s3 url

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

FTP is remote file system. You should have credentials for accessing ftp. Use with prefix "ftp://".


```lucee
<cfscript>
sct.ftp = ftp://#request.ftp.user#:#request.ftp.pass#@ftp53.world4you.com:21/;

dir = directoryList(sct.ftp);
dump(dir);

</cfscript>
```
### Footnotes ###

Here you can see above details in video

[Lucee virtual File System ](https://www.youtube.com/watch?time_continue=693&v=AzUNVYrbWiQ)