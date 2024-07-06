---
title: s3addacl
id: function-s3addacl
related:
categories:
---

Adds ACL to existing ACL for object or bucket. You can provide the endpoint as a bucket/object definition (S3AddACL(bucket:"mybucket",object:"myobject.txt",acl:data) ) or as a virtual filesystem path (S3AddACL(path:"s3://mybucket/myobject.txt",acl:data) ).