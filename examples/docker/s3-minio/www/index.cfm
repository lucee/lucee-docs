<cfscript>
    // "my-bucket" and "hello.txt" are created automatically on startup
    // by the minio-init container (ministack-init/init.sh)

    // VFS — same object via s3:// path
    vfsContent = fileRead("s3:///my-bucket/hello.txt");
	
    // s3* native function — reads object directly
    nativeContent = s3read("my-bucket", "hello.txt");

</cfscript>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lucee S3 + MinIO</title>
    <style>
        body { font-family: sans-serif; max-width: 700px; margin: 40px auto; padding: 0 20px; }
        h2   { color: #555; }
        pre  { background: #f4f4f4; padding: 12px; border-radius: 4px; }
        .label { font-weight: bold; margin-top: 20px; }
    </style>
</head>
<body>
<cfoutput>
<h1>Lucee S3 — MinIO Example</h1>

<p class="label">Native S3 function — <code>s3read("my-bucket", "hello.txt")</code></p>
<pre>#encodeForHTML(nativeContent)#</pre>

<p class="label">Virtual File System — <code>fileRead("s3:///my-bucket/hello.txt")</code></p>
<pre>#encodeForHTML(vfsContent)#</pre>
</cfoutput>
</body>
</html>