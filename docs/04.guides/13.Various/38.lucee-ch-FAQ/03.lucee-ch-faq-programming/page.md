---
title: Programming
id: lucee-ch-faq-programming
---

### Questions related to programming with Lucee ###

**How can I protect my CFML code?**

Instead of encryption, Lucee offers a much more elegant way to protect code when delivering an application to the customer.
Each application can be transformed into a Lucee archive. The only precondition is that the application can be used over a CFML mapping. Note that even "/" is a mapping so that it will be possible to convert every application into a Lucee archive.
The original CFM files are not part of a Lucee archive (Only if you want to have code prints in an error case), only the executable Java byte code. To decompile the original .cfm file out of the byte code contained in a mapping is impossible. Even for us.

**Is Lucee able to read or execute encrypted .cfm files?**

No. The encryption used by CFMX is a format Adobe(formerly Allaire) invented and that can not be interpreted by vendors of other CFML engines.

**How can I use an error page for the different types of errors (404 or CFERROR) with Lucee?**

A 404 error is only noticed by Lucee if you tried to call a .cfm or .cfc page (or all suffixes defined to be handled by Lucee). All other page types are normally handled by the webserver. 
In the first case in the Lucee administrator you can define a .cfm template, that should be called in the case of such an error event.

In the second case you have to define a forwarding rule in case of an error of type 404. 
With the help of the tag <CFERROR> you can always define an own .cfm page for errors that are raised during compile- or runtime.

**What develoment tools are available for Lucee?**

Lucee CFML can be edited with any editor. Syntax highlighting is welcome but not necessary. Especially useful are:

* Dreamweaver
* Of course CFEclipse written by Mark Drew
* CFStudio or HomeSite+ (meanwhile they are outdated but they are still good)