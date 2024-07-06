---
title: s3getacl
id: function-s3getacl
related:
categories:
---

Returns an array of structures, with each structure representing an ACL (Access Control List) grant. You can provide the endpoint as a bucket/object defintion (S3GetACL(bucket:"mybucket",object:"myobject.txt") ) or as a virtual filesystem path (S3GetACL(path:"s3://mybucket/myobject.txt") ).