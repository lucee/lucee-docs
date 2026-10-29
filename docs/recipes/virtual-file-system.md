<!--
{
  "title": "Virtual File Systems",
  "id": "virtual-file-system",
  "related": [
    "function-getvfsmetadata"
  ],
  "categories": [
    "s3",
    "server"
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

Lucee uses virtual file systems for all file operations. Actions like `fileRead(file)` work against any defined filesystem. Each VFS uses a protocol prefix (`http://`, `s3://`, etc.). Without a prefix, the default `file://` (local filesystem) is used.

Built-in:

- file (default)
- ftp
- http / https
- ram
- zip / tgz / tar

Extensions:

- git
- S3

## File (Local)

Default filesystem. Example:

```lucee
<cfscript>
    sct.file = getCurrentTemplatePath();
    sct.directory = getDirectoryFromPath(sct.file);
    dump(sct);

    dump(fileRead(sct.file));
    dump(directoryList(sct.directory));
</cfscript>
```

- `getCurrentTemplatePath` returns the current template path
- `getDirectoryFromPath` returns the directory
- `fileRead` reads the content of a file
- `directoryList` lists all entries in a directory

Explicit `file://` prefix is optional:

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

`[file://]<path>` e.g. `file:///Users/susi/Projects/local/file.txt` or `/Users/susi/Projects/local/file.txt`

## FTP

Treat remote FTP servers as a filesystem. Configure credentials in `Application.cfc`:

```lucee
// How to configure default FTP settings via Application.cfc
this.ftp.username = "secretUser";
this.ftp.password = "secretPW";
this.ftp.host = "ftp.lucee.org";
this.ftp.port = 21;
```

Then use:

```lucee
dir = directoryList("ftp:///dir/file.txt");
dump(dir);
```

Or include credentials in the path:

```lucee
<cfscript>
dir = directoryList("ftp://secretUser:secretPW@ftp.lucee.org:21/dir/file.txt");
dump(dir);
</cfscript>
```

Mix partial credentials from `Application.cfc` with path values - path values override `Application.cfc`.

### Pattern

`ftp://[{user}:{password}@][{host}][:{port}]/{path}` e.g. `ftp://secretUser:secretPW@ftp.lucee.org:21/file.txt`

## HTTP/HTTPS

Read-only filesystem for `get` and `head` calls. No `directoryList()` support. Authentication can be given in the path or per host in the `Application.cfc` (Lucee 9.0+, see [LDEV-3376](https://luceeserver.atlassian.net/browse/LDEV-3376)).

```lucee
<cfscript>
dump(fileRead("https://lucee.org/index.cfm"));
</cfscript>
```

### Credentials

Always use `https://` when you send credentials, with `http://` they travel unencrypted.

#### Credentials in Path

Sends the credentials as HTTP Basic authentication. Less secure - credentials may end up in logs or exceptions.

```lucee
content = fileRead("https://secretUser:secretPW@example.org/protected/file.txt");
```

#### Application.cfc

Define the authentication per host with `this.vfs.http`. The key is the host, optionally with a port (`host:port`). An entry for `host:port` is used before an entry for `host`. Use bracket notation for the keys, as a host name contains dots.

```lucee
// HTTP Basic authentication
this.vfs.http["example.org"].username = "secretUser";
this.vfs.http["example.org"].password = "secretPW";

// arbitrary request headers, e.g. a bearer token or an API key
this.vfs.http["api.example.org:8443"].headers = {
	"Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.EXAMPLE",
	"X-Api-Key": "secretKey"
};
```

```lucee
content = fileRead("https://example.org/protected/file.txt");
content = fileRead("https://api.example.org:8443/data.json");
```

| Key | Description |
|-----|-------------|
| `username` | User name for HTTP Basic authentication. |
| `password` | Password for HTTP Basic authentication. |
| `headers` | Struct of request headers sent with every request to the host. Values must be simple values. |

Rules:

- `username` and `password` are sent with the first request (preemptive), you do not need to wait for a `401` challenge.
- If `headers` contains an `Authorization` header, it is used instead of `username` and `password`.
- Credentials in the path override the authentication of the `Application.cfc` for that request. Other headers defined in `headers` are still sent.
- Headers and credentials are only sent to the host they are defined for. A redirect (`301`, `302`, `303`, `307`, `308`) to another host, port or protocol is followed without them.
- An entry that is not a struct, or `headers` that is not a struct, throws an exception.

### Pattern

`https://[{user}:{password}@]{host}[:{port}]/{path}` e.g. `https://lucee.org/index.cfm`

## RAM/Cache

Treat JVM memory as a filesystem. Fast for temporary files, but data lost on restart (unless backed by cache). RAM filesystem is server/instance-wide - all requests on that Lucee instance share it.

Note: With modern SSDs, the performance difference between RAM and local file operations may be negligible for many use cases.

```lucee
<cfscript>
sct.ram = "ram://";
dump(sct);
dump(directoryCreate(sct.ram & "/heidi/"));
fileWrite(sct.ram & "susi.txt", "sorglos");
dump(directoryList(sct.ram));
</cfscript>
```

### Cache Backing

Back RAM filesystem with a cache for persistence and distribution across servers.

In Lucee Administrator: Services > Cache, define a cache (EHCache, Redis, Couchbase, etc.) then set as default for "Resource".

Or in `Application.cfc`:

```lucee
// link a cache to be used as resource cache
this.cache.resource = "cache"; // name of the cache
```

### Pattern

`ram:///{path}` e.g. `ram:///path/to/my/file.txt`

## ZIP/TGZ/TAR

Access compressed files as filesystems using `zip://`, `tgz://`, or `tar://` prefix.

```lucee
<cfscript>
sct.zip = "zip://path/to/the/zip/test.zip!/path/inside/the/zip/";
dump(directoryList(sct.zip));
dump(fileRead(sct.zip & "/file.txt"));
</cfscript>
```

### Pattern

- `zip://{path-zip-file}!/{path-inside-zip}`
- `tgz://{path-tgz-file}!/{path-inside-tgz}`
- `tar://{path-tar-file}!/{path-inside-tar}`

e.g. `zip://path/to/the/zip/test.zip!/path/inside/the/zip/file.txt`

## S3/Object Storage

Remote filesystem for Amazon S3 and compatible object storage providers:

- Amazon S3
- MinIO
- Wasabi
- Backblaze B2
- Google Cloud Storage
- Microsoft Azure Blob Storage
- IBM Cloud Object Storage
- DigitalOcean Spaces
- Ceph
- Alibaba Cloud OSS
- DreamHost DreamObjects
- Scality RING
- Dell EMC ECS
- Cloudian HyperStore
- OpenIO
- NetApp StorageGRID

Uses `s3://` prefix (originally for Amazon S3, now works with all compatible providers).

### Credentials

#### Environment Variables / System Properties

```sh
LUCEE_S3_ACCESSKEYID: AKIAIOSFODNN7EXAMPLE
LUCEE_S3_SECRETACCESSKEY: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
# optional
LUCEE_S3_HOST: s3.eu-central-1.wasabisys.com
LUCEE_S3_REGION: eu-central-1
LUCEE_S3_ACL: public-read
```

Or system properties: `-Dlucee.s3.accesskeyid`, `-Dlucee.s3.secretaccesskey`, `-Dlucee.s3.host`, `-Dlucee.s3.region`, `-Dlucee.s3.acl`

#### Application.cfc

Single credential set:

```lucee
this.s3.accessKeyId = "AKIAIOSFODNN7EXAMPLE";
this.s3.secretKey = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY";
// optional
this.s3.host = "s3.eu-central-1.wasabisys.com"; // not needed for AWS
this.s3.defaultLocation = "eu-central-1";
this.s3.acl = "public-read";
```

Multiple named credential sets:

```lucee
// my wasabi
this.vfs.s3.mywasabi.accessKeyId = "AKIAIOSFODNN7EXAMPLE";
this.vfs.s3.mywasabi.secretKey = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY";
this.vfs.s3.mywasabi.host = "s3.eu-central-1.wasabisys.com"; // not needed for AWS

// my aws
this.vfs.s3.myaws.accessKeyId = "AKFHJUKHZZHEXAMPLE";
this.vfs.s3.myaws.secretKey = "sdszhHJNkliomi/K7MDENG/bPxRfiCYEXAMPLEKEY";
```

Use named credentials:

```lucee
dir = directoryList("s3://mywasabi@/path/inside/wasabi.txt");
```

#### Credentials in Path

Less secure - credentials may be exposed in exceptions (Lucee 6+ suppresses this, but still risky).

With credentials from environment/Application.cfc:

```lucee
dir = directoryList("s3:///mybucketName/myObjectFolder/myObject.txt");
```

With named credentials:

```lucee
dir = directoryList("s3://mywasabi@/mybucketName/myObjectFolder/myObject.txt");
```

Full credentials in path:

```lucee
dir = directoryList("s3://AKIAIOSFODNN7EXAMPLE:wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY@s3.eu-central-1.wasabisys.com/mybucketName/myObjectFolder/myObject.txt");
dump(dir);
```

### Pattern

`s3://[{access-key-id}:{secret-access} || {name}]@[{host}]/{path-inside-s3}`

e.g. `s3://AKIAIOSFODNN7EXAMPLE:wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY@s3.eu-central-1.wasabisys.com/mybucketName/myObjectFolder/myObject.txt`

## GIT

Access Git repositories as a filesystem - map webroot directly to a repo. Files cached locally, changes auto-detected. Read-only.

### Credentials

#### Environment Variables / System Properties

```sh
LUCEE_GIT_USERNAME: whatever
LUCEE_GIT_PASSWORD: qwerty
```

Or system properties: `-Dlucee.git.username`, `-Dlucee.git.password`

#### Application.cfc

```lucee
this.git.username = "whatever";
this.git.password = "qwerty";
this.git.repository = "https://github.com/lucee/lucee-examples";
this.git.branch = "master";
```

Usage:

```lucee
dir = directoryList("git:///path/inside/repo");
```

Credentials can't be in the path (security), but branch and repository can:

```lucee
dir = directoryList("git://master@github.com/lucee/lucee-examples!/path/inside/repo");
dump(dir);
```

### Pattern

`git://[{branch}@][{repository}]!/{path-inside-repo}` e.g. `git://master@github.com/lucee/lucee-examples!/path/inside/repo`

## Video

[Lucee Virtual File System](https://www.youtube.com/watch?time_continue=693&v=AzUNVYrbWiQ)
