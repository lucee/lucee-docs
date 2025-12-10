<!--
{
  "title": "Checksum",
  "id": "checksum",
  "description": "This document explains how to use a checksum in Lucee.",
  "keywords": [
    "Checksum",
    "File validation",
    "cfhttp",
    "hash",
    "fileReadBinary"
  ],
  "related": [
    "function-fileReadBinary",
    "tag-http"
  ],
  "categories": [
    "crypto"
  ]
}
-->

# Checksum

Validate downloads using checksums provided in response headers.

## Download and Validate

```luceescript
<cfscript>
_url="http://central.maven.org/maven2/org/lucee/esapi/2.1.0.1/esapi-2.1.0.1.jar";
http url=_url result="res";
if(res.status_code!=200) throw "wtf";
dump(res.responseheader);

// store the file
localFile="esapi-2.1.0.1.jar";
fileWrite(localFile,res.fileContent);

// get a hash
dump(fileInfo(localFile));
dump(hash(fileReadBinary(localFile),"md5"));
dump(hash(fileReadBinary(localFile),"SHA1"));


// validate file
if(!isEmpty(res.responseheader["X-Checksum-MD5"]?:"")) {
fi=fileInfo("esapi-2.1.0.1.jar");
if(res.responseheader["X-Checksum-MD5"]==fi.checksum) {
dump("we have a match!");
}
else {
fileDelete("esapi-2.1.0.1.jar");
dump("something went wrong! give it another try?");
}
}
</cfscript>
```

Check `X-Checksum-MD5` or `X-Checksum-SHA1` headers against `fileInfo().checksum` or `hash(fileReadBinary(file), "md5")`.

## Providing Checksum Headers

```luceescript
<cfscript>
// download.cfm
fi=fileInfo("esapi-2.1.0.1.jar");
header name="Content-MD5" value=fi.checksum;
content file="esapi-2.1.0.1.jar" type="application/x-zip-compressed";
</cfscript>
```

## Validate with Multiple Header Types

```luceescript
<cfscript>
// possible MD5 headers
HEADER_NAMES.SHA1=["Content-SHA1","X-Checksum-SHA1"];
HEADER_NAMES.MD5=["Content-MD5","X-Checksum-MD5"]; // ETag
_url=getDirectoryFromPath(cgi.request_url)&"/_download.cfm";

http url=_url result="res";
if(res.status_code!=200) throw "wtf";

// store the file
fileWrite("clone.jar",res.fileContent);

// see if we have one of the MD5 headers
checksum={type:"",name:""};
loop label="outer" struct=HEADER_NAMES index="type" item="names" {
loop array=names item="name" {
if(structKeyExists(res.responseheader,name)) {
checksum.type=type;
checksum.name=name;
checksum.value=res.responseheader[name];
break outer;
}
}
}
dump(checksum);

// validate file
if(!isEmpty(checksum.name)) {
cs=hash(fileReadBinary("clone.jar"),checksum.type);
//dump(checksum);
if(checksum.value==cs) {
dump("we have a match!");
}
else {
fileDelete("clone.jar");
dump("something went wrong! give it another try?");
}
}
</cfscript>
```

Video: [Checksum](https://www.youtube.com/watch?v=Kb_zSsRDEOg)
