<!--
{
  "title": "Using S3 directly for source code",
  "id": "using-s3-directly-for-source-code",
  "categories": [
    "s3"
  ],
  "description": "Using S3 directly for source code",
  "keywords": [
    "S3",
    "Source code",
    "Credentials",
    "Mapping",
    "Caching"
  ]
}
-->

# Using S3 directly for source code

This document explains how to use S3 as for your source code and how to use S3 for your artifacts when we look at the source code itself.

## Example:

```luceescript
// get an image directly from s3
content file = "s3:///cfml1/lucee.png" type = "image/png"
"s3://##:#awsSecretKey#@/";
```

//Application.cfc

```luceescript
component{
	this.name = 'exampleS3';
	this.s3.accesskeyid = "JHKLJHGSGSGVSGVS";
	this.s3.awssecretkey = "Jgftiutry3uwiumcx4bvhjf9ksepu5wrwnvwbh9gj";
}
```

1. In this example we directly call an S3 resource of the image using `file="s3:///cfml1/lucee.png"` and also define the mime type. Then we see the image while calling it in the browser.

2. In this example, we define the credentials of the S3 in the Application.cfc. Here we give dummy data for the accesskey Id and secretkey.

3. In this example, if you have an exception, it will display on the page exposing your credential information. So, we never use an error template that shows the exception. Best practice is to never use the credential with the password itself. Instead, always defined it in the application.cfc

4. Another option is to map with the admin.

   - Virtual : /s3
   - Resource : s3://somethingLikeThis@/

But again, that would expose your credentials for everybody that sees an exception message.

5. Instead, set the credentials in the environment variable or system properties (This is a new feature in S3 0.9.4.118). So, we can remove the resource in the mapping and just simply define `Resource : s3:///cfml1/` and save this mapping.

6. Two important things in mapping.

   - When enabling the flag `Web Accessible`, this exposes that mapping directly to the user. So you can call it at /s3 in the browser.
   - When removing the flag `Web Accessible`, you can only include that mapping. So, we always use cfinclude s3.

7. If we select `Never` in 'Inspect Templates' this tells Lucee to pick up the file on first request from s3. It will compile the file to a local folder. Then it will only use that local compiled file and never check again if the file has changed.

8. We go to `localhost:8888/s3/cfml1/index.cfm` in the browser. We get the source from S3 which comes directly from a stream, so we are catching that. It will not pick up any changes at all. For example, if we change that file a little bit and then update the file on s3, and then call it again in the browser, it does not pick up the latest changes. Because it is cached, what you now can do is flush the change with the help of the function `PagePoolClear()`. This function will create a complete page pool.

9. Lucee will pick up the file including the new changes when we call and execute again. Here you have cached and flushed the cache manually. If you add new files to the s3, you can automate that step.

It might be very useful to schedule a task that checks every five minutes or so to see if there are changes in the files on S3, and flush everything is there are changes.

## Footnotes

Here you can also see these details in the video:

[S3 for source code](https://youtu.be/twQomRCbaCY)
