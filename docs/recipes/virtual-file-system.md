<!--
{
  "title": "Virtual File Systems",
  "id": "virtual-file-system",
  "related": [
    "function-getvfsmetadata"
  ],
  "categories": [
    "s3",
    "system"
  ],
  "description": "Lucee supports the following virtual file systems: ram, file, s3, http, https, zip, and tar.",
  "keywords": [
    "Virtual File System",
    "VFS",
    "Local File System",
    "ZIP",
    "RAM",
    "S3",
    "FTP",
    "git",
    "HTTP",
    "MinIO",
    "Wasabi",
    "Backblaze B2",
    "Google Cloud Storage",
    "Microsoft Azure Blob Storage",
    "IBM Cloud Object Storage",
    "DigitalOcean Spaces",
    "Ceph",
    "Alibaba Cloud OSS",
    "DreamHost DreamObjects",
    "Scality RING",
    "Dell EMC ECS",
    "Cloudian HyperStore",
    "OpenIO",
    "NetApp StorageGRID"
  ]
}
-->

# Virtual File Systems

Lucee uses virtual file systems for all file interactions. Actions like `fileRead(file)` can be done against any filesystem defined. Every virtual filesystem is addressed with a protocol prefix like "http" or "s3". When no protocol prefix is defined, the default "virtual" file system "file" is used, which is the local filesystem (can be changed).

Lucee supports the following virtual file systems out of the box:

- file (default)
- ftp
- http / https
- ram
- zip / tgz / tar

Additionally, there are extensions for the following virtual file systems:

- git
- S3

## File - Local File System

You may already be familiar with local file systems. The local file system is the default file system in Lucee. That means if there is no other definition, Lucee will always use the local file system.

A simple example:

```lucee
<cfscript>
    sct.file = getCurrentTemplatePath();
    sct.directory = getDirectoryFromPath(sct.file);
    dump(sct);

    dump(fileRead(sct.file));
    dump(directoryList(sct.directory));
</cfscript>
```

- `getCurrentTemplatePath` returns the current template path.
- `getDirectoryFromPath` returns the directory.
- Pass the file path to `fileRead` to read the content of the file.
- Pass the directory to `directoryList` to list all the directories in the given folder path.

However, you can explicitly define the file system you want to use. To use a local file system, use the `file://` prefix.

As seen in the example code above, the local file system is the default, so it is not necessary to explicitly define it. The example below shows how you can explicitly define a local file system. The result is the same as the code above.

```lucee
<cfscript>
    sct.file = getCurrentTemplatePath();
    sct.directory = getDirectoryFromPath(sct.file);
    dump(sct);

    sct.file = "file://" & sct.file;
    sct.directory = "file://" & sct.directory;

    dump(sct);
    dump(fileRead(sct.file));
    dump(directoryList(sct.directory));
</cfscript>
```

### Pattern

`[file://]<path>`
so for example
`file:///Users/susi/Projects/local/file.txt`
or simply
`/Users/susi/Projects/local/file.txt`

## FTP File System

Lucee allows you to treat a remote FTP server as a virtual filesystem.

You will need access credentials for accessing FTP. Set up an FTP file system using the prefix `ftp://`.

You can define the credentials in the Application.cfc like this

Application.cfc

```lucee
// How to configure default FTP settings via Application.cfc
this.ftp.username = "secretUser";
this.ftp.password = "secretPW";
this.ftp.host = "ftp.lucee.org";
this.ftp.port = 21;
```

Then you can simply do an FTP call like this:

```lucee
dir = directoryList("ftp:///dir/file.txt");
dump(dir);
```

But you can also put everything in the path directly with no definition in the Application.cfc like this:

```lucee
<cfscript>
dir = directoryList("ftp://secretUser:secretPW@ftp.lucee.org:21/dir/file.txt");
dump(dir);
</cfscript>
```

Or take parts from Application.cfc and define other parts directly like this:

Application.cfc

```lucee
// How to configure default FTP settings via Application.cfc
this.ftp.username = "secretUser";
this.ftp.password = "secretPW";
```

```lucee
<cfscript>
dir = directoryList("ftp://ftp.lucee.org:21/dir/file.txt");
dump(dir);
</cfscript>
```

Values in the path directly always overwrite parts coming from the Application.cfc

### Pattern

`ftp://[{user}:{password}@][{host}][:{port}]/{path}`
so for example
`ftp://secretUser:secretPW@ftp.lucee.org:21/file.txt`

## HTTP/HTTPS Filesystem

This is a read-only filesystem that makes essential `get` and `head` calls to an HTTP server, with limited functionality. Because of the nature of HTML, things like `directoryList("http://...")` are not possible. This file system also does not support credentials or any definition in the Application.cfc.

```lucee
<cfscript>
dump(fileRead("https://lucee.org/index.cfm"));
</cfscript>
```

### Pattern

`https://{host}[:{port}]/{path}`
so for example
`https://lucee.org/index.cfm`

## RAM/Cache File System

RAM is a virtual file system that allows you to treat the memory of the JVM as a file system.
This is useful for storing temporary files, and it is very fast since it uses the system's RAM. This data will be lost when the server restarts (unless you use a cache; see below).

The RAM file system is configured with the `ram://` prefix.

```lucee
<cfscript>
sct.ram = "ram://";
dump(sct);
dump(directoryCreate(sct.ram & "/heidi/"));
fileWrite(sct.ram & "susi.txt", "sorglos");
dump(directoryList(sct.ram));
</cfscript>
```

### Cache

In addition, you can define a Cache in the Lucee Administrator or in the Application.cfc that then is used to store the data.
With this cache, this file system can be distributed across multiple servers and can also survive a restart of the Server.

#### Define a cache in the Admin

In the Lucee Administrator under "Services/Cache" you can define a cache (EHCache, Redis, Couchbase, ...) and then below "Default cache connection",
you define that cache as default for "Resource".

#### Define a cache in the Application.cfc

In the Application.cfc you simply define the following:

```lucee
// link a cache to be used as resource cache
this.cache.resource = "cache"; // name of the cache
```

### Pattern

`ram:///{path}`
so for example
`ram:///path/to/my/file.txt`

## ZIP/TGZ/TAR File System

Another file system you can use in Lucee is the ZIP/TGZ/TAR file system to access a compressed file like a file system.
To tell Lucee to use a compressed file system, use the prefix `zip://`, `tgz://`, or `tar://`.

Now the file path will look like `zip://path/to/the/zip/test.zip!/path/inside/the/zip/file.txt`.

```lucee
<cfscript>
sct.zip = "zip://path/to/the/zip/test.zip!/path/inside/the/zip/";
dump(directoryList(sct.zip));
dump(fileRead(sct.zip & "/file.txt"));
</cfscript>
```

### Pattern

`zip://{path-zip-file}!/{path-inside-zip}`
`tgz://{path-tgz-file}!/{path-inside-tgz}`
`tar://{path-tar-file}!/{path-inside-tar}`
so for example
`zip://path/to/the/zip/test.zip!/path/inside/the/zip/file.txt`

Next to the bundled virtual file system, there are other file systems available as extensions you can install when needed.

## Object Storage/S3 File System

Object Storage/S3 is a remote file system you can use for Amazon S3 storage.

### Support for different providers

Lucee not only supports access to Amazon S3 cloud storage, it also allows using the same file system to access other Object storage providers:

- Amazon S3 - Cloud Storage
- MinIO - Open-source Object Storage
- Wasabi - Cloud Storage
- Backblaze B2 - Cloud Storage
- Google Cloud Storage - Cloud Storage
- Microsoft Azure Blob Storage - Cloud Storage
- IBM Cloud Object Storage - Cloud Storage
- DigitalOcean Spaces - Cloud Storage
- Ceph - Open-source Storage Platform
- Alibaba Cloud OSS - Cloud Storage
- DreamHost DreamObjects - Cloud Storage
- Scality RING - Software-defined Storage
- Dell EMC ECS - Enterprise Object Storage
- Cloudian HyperStore - Object Storage
- OpenIO - Open-source Object Storage
- NetApp StorageGRID - Object Storage Solution

Traditionally only Amazon S3 Cloud Storage was supported, because of that the prefix `s3://` is used.

### Credentials

The credentials needed to access can be provided in various ways.

#### Environment Variables / System Properties

You can define the credentials with the help of Environment Variables/System Properties. In that case, only a single set of credentials is possible. These are the possible settings:

Environment Variables

```sh
LUCEE_S3_ACCESSKEYID: AKIAIOSFODNN7EXAMPLE
LUCEE_S3_SECRETACCESSKEY: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
# optional
LUCEE_S3_HOST: s3.eu-central-1.wasabisys.com
LUCEE_S3_REGION: eu-central-1
LUCEE_S3_ACL: public-read
```

System Properties

```sh
-Dlucee.s3.accesskeyid: AKIAIOSFODNN7EXAMPLE
-Dlucee.s3.secretaccesskey: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
# optional
-Dlucee.s3.host: s3.eu-central-1.wasabisys.com # not needed for AWS
-Dlucee.s3.region: eu-central-1
-Dlucee.s3.acl: public-read
```

#### Application.cfc

You can define the credentials in the Application.cfc as a single set like this:

```lucee
this.s3.accessKeyId = "AKIAIOSFODNN7EXAMPLE";
this.s3.secretKey = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY";
// optional
this.s3.host = "s3.eu-central-1.wasabisys.com"; // not needed for AWS
this.s3.defaultLocation = "eu-central-1";
this.s3.acl = "public-read";
```

But you can also do multiple entries and give everyone a name.

```lucee
// my wasabi
this.vfs.s3.mywasabi.accessKeyId = "AKIAIOSFODNN7EXAMPLE";
this.vfs.s3.mywasabi.secretKey = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY";
this.vfs.s3.mywasabi.host = "s3.eu-central-1.wasabisys.com"; // not needed for AWS

// my aws
this.vfs.s3.myaws.accessKeyId = "AKFHJUKHZZHEXAMPLE";
this.vfs.s3.myaws.secretKey = "sdszhHJNkliomi/K7MDENG/bPxRfiCYEXAMPLEKEY";
```

In the code, they can be used like this:

```lucee
dir = directoryList("s3://mywasabi@/path/inside/wasabi.txt");
dump(dir);
```

#### Define the credentials as part of the path

This is the least secure option because it takes the risk that your credentials get exposed to the user in case of an exception. Lucee 6 and beyond suppress this data, but it's still a risk.

So, in case you have defined your credentials in the environment or in the Application.cfc like described above, you can simply use it like this:

```lucee
dir = directoryList("s3:///mybucketName/myObjectFolder/myObject.txt");
dump(dir);
```

In case you have defined it in the Application.cfc with the help of `this.vfs.s3` with a name, you can use it like this:

```lucee
dir = directoryList("s3://mywasabi@/mybucketName/myObjectFolder/myObject.txt");
dump(dir);
```

Or if you want to pass all data into the path, it would look like this:

```lucee
dir = directoryList("s3://AKIAIOSFODNN7EXAMPLE:wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY@s3.eu-central-1.wasabisys.com/mybucketName/myObjectFolder/myObject.txt");
dump(dir);
```

### Pattern

`s3://[{access-key-id}:{secret-access} || {name}]@[{host}]/{path-inside-s3}`
so for example:
`s3://AKIAIOSFODNN7EXAMPLE:wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY@s3.eu-central-1.wasabisys.com/mybucketName/myObjectFolder/myObject.txt`

## GIT File System

GIT is a virtual filesystem that allows you to access GitHub like a filesystem, so you can, for example, map your webroot directly to a GitHub repository. The extension caches the files locally for faster access and recognizes any changes made on GitHub.

### Credentials

The credentials needed to access a private repository can be provided in different ways.

#### Environment Variables / System Properties

You can define the credentials with the help of Environment Variables/System Properties. In that case, only a single set of credentials is possible. These are the possible settings:

Environment Variables

```sh
LUCEE_GIT_USERNAME: whatever
LUCEE_GIT_PASSWORD: qwerty
```

System Properties

```sh
-Dlucee.git.username: whatever
-Dlucee.git.password: qwerty
```

#### Application.cfc

You can define the credentials in the Application.cfc like the following. Additionally, you can define the name and branch of the repository you want to access.

```lucee
this.git.username = "whatever";
this.git.password = "qwerty";
this.git.repository = "lucee-examples";
this.git.branch = "master";
```

In the code, this can be used as follows when you have defined everything in the environment (for example, Application.cfc).

```lucee
dir = directoryList("git:///path/inside/git");
dump(dir);
```

It is not possible to define the credentials as part of the path (for security reasons), but you can define "branch" and "repository" in the path like this:

```lucee
dir = directoryList("git://master@/path/inside/git!lucee-examples");
dump(dir);
```

### Pattern

`git://[{branch}@]/{path-inside-git}[!{repository}]`
so for example:
`git://master@/path/inside/git!lucee-examples`

## Footnotes

Here you can see the above details in a video:

[Lucee virtual File System](https://www.youtube.com/watch?time_continue=693&v=AzUNVYrbWiQ)
