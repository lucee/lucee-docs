---
title: Lucee Resources
id: lucee-resources
---

### Extend your file system with any virtual file system ###

With Lucee 2.0 we introduced resources. Resources are what we call virtual file systems. Resources can be used in any file related tag or function. By default Lucee supported the following File System Types.

In Lucee 3.0 we introduced the S3 (Amazon Simple Storage Service) resource which allows you to connect to any buckets you want to use your Amazon S3 account. Resources can be used very easily. The following code fragment should clarify this fact:

```lucee
<cffile action="write" file=ftp://user:pass@www.mysite.com/file.txt" output="#var#">
```

All other file related tags like ```<cfmodule>```, ```<cfdirectory>``` can be used in the same manner, just like all file related functions like ```fileExists()```, ```directoryExists()``` etc. So it will be possible to use the following construct:

```lucee
<cfset bFileIsThere = FileExists("db://user:pass@datasource/file.txt")>
```

You can use the resource notation in most of the Admin settings. So if you define a mapping to a distant resource you can use CFINCLUDE for it.

What's interesting about resources is, is the fact that you as a programmer do not need to know how the file is reaching its destination. You just use your regular commands with the specified syntax and the rest happens in the background. Lucee takes care of it. The following image should display this functionality:

This command copies the file myFile.cfm from the local server?s RAM to the distant ftp server at ftp.myserver.com. Now just imagine how much effort this would cost, if you would try to do this with regular tools in CFML.


### Mappings ###

An other advantage is the usage of resources with mappings. You can define your mappings as follows (not to mention the fact, that you can use resources together with archives stored in a resource):

```lucee
Virtual        Physical
/ram           ram://cfm-files
/liveserver    ssh://username:password@www.live.com/webroot/publishfiles
/testserver    ftp:// username:password@www.test.com/webroot/publishfiles
```

Now an application can use the defined mappings as follows:

```lucee
<CFSET aPublicationMappings = Array("/liveserver","/testserver")>
<CFLOOP index="iMapping" to="#arrayLen(aPublicationMappings)#" from="1">
    <CFLOOP index="iFile" to="#arrayLen(aPublishFiles)#" from="1">
        <CFFILE 
            action="COPY" 
            source="/staging/#aPublishFiles[iFile]#" 
            destination="#aPublicationMappings[iMapping]#/#aPublishFiles[iFile]#"> 
    </CFLOOP>
</CFLOOP>
```

The important thing here is to know, that it is not necessary to implement the different methods for the different publish methods (FTP, SFTP, SSH etc.). Just use Lucee resources. If you for example like to copy a file from the staging server to the live server just use the cffile tag and the two defined mappings.

Done.

### Real World Example ###

The Lucee interface allows an own implementation of a special ressource. How you do this will be shown in one of the upcoming blogs.

We have taken a real world example in order to test the Lucee resources. Therefor we used the filemanager CFFM by Rick Root. CFFM can browse through defined mappings as well. So we defined a special mapping into the server's ram and we were not only able to upload a file into the ram but we were also able to modify it accordingly. CFFM does not know anything about resources, but he does know how to handle mappings. The fact that resources obey the usual usage of file tags and functions without introducing new attributes made it possible that CFFM worked without changes. So even though CFFM does not know anything about FTP, RAM or ZIP, you could use it in order to browse through these file systems.

With this technique you could even use CFFM as a bucket explorer for your Amazon S3 files. Just create a mapping pointing to it and then register the mapping in the source of the CFFM code.