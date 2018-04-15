---
title: Projects
id: lucee-ch-faq-projects
---

### Questions related to the implementation of existing projects ###

**How can I convert an existing projekt from an other CFML engine to Lucee in the fastest and easiest way?**

If you have installed Lucee correctly and a regular test-cfm page is processed accordingly, you can define a mapping (only temporary) to your application.
This mapping can be compiled by clicking on the designated button. If the compile process is not successful (only compilation errors), you can check the file /rootdesmappings/compile_errors.log (applying only to Version 1.1) for a list of all compile errors. You can now repeat this operation as often as necessary.
After successful compilation you need to test your application by clicking through it.

**What are the most common errors when converting a project from CFMX to Lucee?**

The most common Mistakes when converting a project from Adobe® ColdFusion®-MX 7.x to Lucee are:
1. Inline Comments
Lucee does not support these constructs. Comments should be made before or after a tag.
The following construct throws a compilation error:

```<cfoutput query="myQuery">```

1. Unsupported tags
In the version 1.0, Lucee is nearle 100% compatible to Adobe® ColdFusion®-MX 6.1. However there are some tags that are not supported. Here is a list of all [unsupported](https://web.archive.org/web/20090328155319/http://railo.ch:80/en/index.cfm?treeID=274) tags. A corresponding error message appears during the compilation process.
1. Unsupported attributes
Some attributes are supported by Lucee starting with version 1.1. A corresponding error message appears during the compilation process there too. An unsupported attribute is for instance the forcenewline="boolean" attribute used in the tag CFFILE.
1. Uncorrect written attributes
In contrary to Adobe® ColdFusion®-MX 7.x, Lucee is very restrikt concerning the correct writing of attributes betrifft. If an attribute is misspelled under Adobe® ColdFusion®-MX 7.x it will simply be ignored, whereas Lucee stops the compilation and throws an eror. In fact there are companies which use Lucee to check their code for syntax errors by compiling it with Lucee in order to make sure it runs under every engine. If it runs under Lucee, it will definitely run under Adobe® ColdFusion®-MX 7.x if no special Lucee extensions have been used.
The attribute output="true" used within the tag <cfargument> will be ignored under Adobe® ColdFusion®-MX 7.x. This was the case in the core files of Fusebox 4.1.
You can argue about it but the more flexible an engine is the slower it is.
1. Encrypted code
Adobe® ColdFusion®-MX 7.x supports encryption of .cfm files. This is mainly used in order to protect code and with it the knowledge of a programmer. Adobe® ColdFusion®-MX 7.x decrypts the code on the fly and executes it subsequently. Since this encryption is a proprietary solution of Adobe® and it is protected by law, Lucee must and can not decrypt and execute this type of code. Therefore you are dependant to have the source of an application from the supplier, or that he delivers a Lucee archive containing the application.
Now there comes the question how to protect someone's code. Just check the FAQ How can I protect my code? in order to find out.