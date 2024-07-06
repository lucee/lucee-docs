---
title: s3setacl
id: function-s3setacl
related:
categories:
---

Sets ACL to existing ACL for object or bucket. You can provide the endpoint as a bucket/object defintion (S3SetACL(bucket:"mybucket",object:"myobject.txt",acl:data) ) or as a virtual filesystem path (S3SetACL(path:"s3://mybucket/myobject.txt",acl:data) ).