---
title: Define a mapping
id: cookbook-filesystem-mapping-define-mapping
related:
- tag-application
- cookbook-application-context-set-mapping
---

# How to define a regular Mapping #

Lucee allows you to define a mappings to a specific location in a filesystem, so you don't always have to use the full path, in most cases the full path is not working anyway, for example with <cfinclude> does not work with a full path.
This is supported with all filesystems Lucee supports (local,ftp,http,ram,zip,s3 ...).

## Create a regular Mapping in the Administrator ##
The most common way is to define a regular Mapping is in the Lucee Server or Web Administrator.
The only difference between the Web and Server Administrator is, that a mapping defined in the Server Administrator is visible to all web contexts and a mapping defined in the Web Administrator only to the current web context.
In your Administrator go to the Page "Archives & Resources/Mappings", in the section "create new Mapping" that looks like this.

![create-mapping.png](https://bitbucket.org/repo/rX87Rq/images/4035761629-create-mapping.png)

With "Virtual" choose the virtual path for the mapping, this is the path you will later use to address this mapping.

"Resource" is the physical location where the mapping is pointing to, for example "C:\Projects\whatever\test".

With "Archive" you can map a Lucee archive (more below) to the mapping.

"Primary" defines where a template is searched first, let's say you have set primary to "archive" and you execute the following code

```coldfusion
<cfinclude template="/myMapping/test.cfm">
```
in that case Lucee is first checking the archive associated with the "/myMapping" mapping for "test.cfm", if the template is not found it there, Lucee also checks the physical location.

"Inspect templates" defines the rule for Lucee when and if to check changes in source templates and if necessary recompile them.

* never - once the template is compiled and loaded Lucee never check for changes as long the template is not unloaded (restart server)
* once - Lucee only checks with the first access within a request if the template has changed
* always - Lucee checks with every access to the file if the file has changed
* inherit - The mapping has no setting at all, it inherits the "inspect templates" setting made in "Settings - Performance/Caching"

"Web accessible" defines if you can call the mapping directly from the browser or not, "/lucee" for example is a web accessible mapping, because of that you can call it in the browser as follows "/lucee/admin.cfm".

### Compile the CFML Code inside a mapping ###

In the detail view of a single mapping you can compile all cfm and cfc files in that mapping to test if they are syntactically correct. With the flag "stop on error" you can define if the process should stop if the compiler fails.

![compile.png](https://bitbucket.org/repo/rX87Rq/images/362153996-compile.png)

### Create an archive from a mapping ###
In the detail view of a single mapping you can create an archive that contains all templates of the mapping in compiled form.
With the flag "Add CFML Templates" you can define if Lucee should add the source version of the templates as well, this make sense when you need a proper error output in case of an  exception (source code output) or you need to read the content of this files for example with <cffile>.
With the flag "Add Non CFML Templates"  you can define if Lucee should add all non CFML files (png,js,gif,css ...) as well, this make sense when you need to read the content of this files for example with <cffile>.

![create-archive.png](https://bitbucket.org/repo/rX87Rq/images/2720116188-create-archive.png)

By clicking the button "download archive" you create the archive and then you can download it directly, with the button "assign archive to mapping" you can create the mapping and directly add to the current mapping.


## Create a Mapping in the Application.cfc ##
Lucee allows to create mappings in your Application.cfc, this mappings are only valid for the current request.

```cfs
// Application.cfc
component {
    this.mappings['/shop']=getDirectoryFromPath(getCurrentTemplatePath())&"shop";
}
```
We define the mappings as a struct, where the key of the struct is the virtual path.

Now you can simply use that mapping in your code

```coldfusion
<cfinclude template="/shop/whatever.cfm"> <!--- load a template from the "shop" mapping --->
<cfset cfc=new shop.Whatever()><!--- load a CFC from the "shop" mapping (see also "this.componentpaths" for handling components)  --->
```
## Advanced ##
In the previous example we have simply set a path, like you can see in the Administrator, a mapping can contain more data than only a physical path, of course you can use this settings also with a mapping done in the Application.cfc.

```cfs
// Application.cfc
component {
   this.mappings['/shop']={
      physical:getDirectoryFromPath(getCurrentTemplatePath())&"shop",
      archive:getDirectoryFromPath(getCurrentTemplatePath())&"shop.lar",
      primary:"archive"
   };
}
```
In that case we not only define a physical path, we also define a Lucee archive (.lar). "primary" defines where Lucee is checking first for a resource, let's say you have the following code

```coldfusion
   <cfinclude template="/shop/whatever.cfm">
```
In that case Lucee first checks in the archive for "whatever.cfm" , if not found there, it looks inside the physical path.

### Site Note ###
Of course this can be done for all mapping types

```cfs
// Application.cfc
component {
   this.componentpaths=[{archive:getDirectoryFromPath(getCurrentTemplatePath())&"testbox.lar"}];// loading testbox from an archive
   this.customtagpaths=[{archive:getDirectoryFromPath(getCurrentTemplatePath())&"helper.lar"}];// a collection of helper custom tags

   };
}
```
