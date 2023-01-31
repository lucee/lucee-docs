
<!--
{
  "title": "Regions in Lucee",
  "id": "s3-regions",
  "related": [
    "virtual-file-system"
  ],
  "categories": [
    "s3",
    "cloud",
    "object-storage"
  ],
  "description": "Guide on configuring and interacting with specific S3 regions in Lucee using the S3 extension.",
  "keywords": [
    "Virtual File System",
    "VFS",
    "S3",
    "Regions",
    "Buckets",
    "Amazon S3",
    "Wasabi",
    "MinIO",
    "Cloud Storage"
  ]
}
-->

# Using S3 Regions in Lucee

This guide explains how to configure and use S3 regions in Lucee, focusing on two methods of interaction: the [virtual file system (VFS)](https://github.com/lucee/lucee-docs/blob/master/docs/recipes/virtual-file-system.md) interface and the function interface. Both interfaces can be used with configuration settings defined in `Application.cfc`, system properties, or environment variables.

## 1. Configuring S3 Regions

You can define your default S3 region in `Application.cfc` with the `defaultLocation` setting. Alternatively, use system properties or environment variables to set up region-specific configurations that Lucee will use across both the VFS and function interfaces. This configuration is the default region applied when no specific region is passed in a function or VFS path.

### Configuration in Application.cfc

```lucee
this.s3.defaultLocation = "us-west-2"; // Sets the default region for S3
this.s3.accessKeyId = "your-access-key-id";
this.s3.secretKey = "your-secret-access-key";
```

### Configuration via Environment Variables

Environment variables allow you to set the region along with access credentials, providing an alternative method for configuration.

```sh
LUCEE_S3_ACCESSKEYID=your-access-key-id
LUCEE_S3_SECRETACCESSKEY=your-secret-access-key
LUCEE_S3_REGION=us-west-2
```

## 2. Specifying Regions in VFS and Functions

In addition to using the default configuration, you can specify a region directly when using the VFS interface or function interface. This approach is especially helpful when you need to interact with buckets located in different regions.

### VFS Interface with Specified Region

For the VFS interface, the region can be included in the hostname within the URL structure:

```lucee
<cfset dir = directoryList("s3://your-access-key-id:your-secret-access-key@s3.eu-central-1.wasabisys.com/mybucketName/myObjectFolder/")>
```

### Function Interface with Optional Region Argument

Certain S3-related functions, particularly those that create or modify buckets, allow you to specify the region as an optional argument. For instance:

```lucee
<cfset S3CreateBucket(bucket:"exampleBucket", region:"us-west-2")>
```

However, most object manipulation functions (e.g., `S3Copy`, `S3Move`, `S3Upload`) do not require a region argument, as they inherit the region from the bucket.