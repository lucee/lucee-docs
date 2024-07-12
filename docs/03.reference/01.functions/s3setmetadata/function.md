---
title: s3setmetadata
id: function-s3setmetadata
related:
categories:
---

Sets the metadata on bucket or object. You can provide the endpoint as a bucket/object definition (S3SetMetaData(bucket:"mybucket",object:"myobject.txt",metadata:data) ) or as a virtual filesystem path (S3SetMetaData(path:"s3://mybucket/myobject.txt",metadata:data) ).