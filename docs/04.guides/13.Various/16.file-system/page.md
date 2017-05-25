---
title: File System Types
id: file-system-types
---

Lucee gives you access to a number of resources

### Local Files ###

Provides access to the files on the local physical file system.

### Format ###

```lucee
[file://] absolute-path
```

Where absolute-path is a valid absolute file name for the local filesystem.

Examples

```lucee
/home/someuser/somedir

c:\program files\some dir

c:/program files/some dir

file://home/someuser/somedir

file://C:/Documents and Settings

file:////somehost/someshare/afile.txt
```

### Zip, Tar and TGZ ###

Provides access to the contents of Zip, Tar and TGZ files.

### Format ###

```lucee
zip:// arch-file-uri [! absolute-path ]

tar:// arch-file-uri [! absolute-path ]

tgz:// arch-file-uri [! absolute-path ]
```

Where arch-file-uri refers to a file of any supported type, including other zip files.

### Examples ###

```lucee
zip://c:/somedir/somefile.zip!/zipdir/file.txt

tgz://file://Users/susi/somefile.tar.gz!/zipdir/file.txt

tar:///Users/susi/somefile.tar!/zipdir/file.txt
```

### HTTP ###

Provides readonly access to files on an HTTP server.

### Format ###

```lucee
http://[ username [: password ]@] hostname [: port ][ absolute-path ]
```

### Examples ###

```lucee
http://somehost:8080/downloads/pic.gif

http://myUserName:myPassword@myHost/index.html
```

### FTP ###

Provides access to the files on an FTP server.

### Format ###

```lucee
ftp://[ username [: password ]@] hostname [: port ][ absolute-path ]
```

### Examples ###

```lucee
ftp://myUsername:myPassword@somehost/pub/downloads/somefile.zip
```

### RAM ###

A filesystem which stores all the data in memory.

### Format ###

```lucee
ram://[ path ]
```

### Examples ###

```lucee
ram:///any/path/to/file.txt
```

### S3 ###

Provides access to the files on an S3 (Simple Storage Service) Internet Storage

### Format ###

```lucee
s3://accessKey:secretAccessKey@amazonaws.com[ absolute-path ]
```

### Examples ###

```lucee
s3://ddsfdsfer34ewe:ewdkwhekwrh3432@amazonaws.com/somedir/somefile.txt
```