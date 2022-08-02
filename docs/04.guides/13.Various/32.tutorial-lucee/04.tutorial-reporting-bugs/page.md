---
title: Lucee Support - How to report bugs/problems and get help
id: tutorial-reporting-bugs
menuTitle: How to report bugs
---

### How to report a bug in Lucee ###

First, thank you for evaluating Lucee and taking the time to report issues. 

The Lucee Team cannot stress how important it is to have an active open source community and reporting issues is one of the many ways in which you can participate and be involved.

## Research

Before reporting a bug, please search for existing bug reports in the [Lucee issue tracker](https://luceeserver.atlassian.net/) and in the [Lucee mailing list archives](https://dev.lucee.org).

If you are using an older Lucee release, please check first if the problem has already been fixed in the latest RELEASE or SNAPSHOT

## Post to the mailing list/form about the problem

[Lucee mailing list / developer form](https://dev.lucee.org)

Please always try to include enough detailed information so that others can understand your problem, most importantly, and please always state which version of Lucee you are using, it really helps.

Always ask yourself, how would I respond to this bug report (is there something missing which will help solve it)?

Once the has been discussed/triaged on the mailing list, you may be asked to file a bug.

*PLEASE DON"T JUST GO AND FILE A BUG* 

### Give tickets a self-explanatory title and context ###

Good titles. A ticket title like `createTimeSpan fails` isn't very useful to anyone, as it doesn't provide any context, but `queryExecute createTimeSpan never caches in a script based cfc` does.

Good titles makes it is easier for other developers to understand what the issue is about, 

## Provide Version and Environment information ##

When a bug is posted the first thing we do is to try to reproduce it. It is very important to have information about the environment where the issue was detected.

* Operating System
* Lucee Version and deployment ( Ex: Lucee 5.3.7.47 / Tomcat 9.5 | Commandbox )
* Java Version (i.e. 1.8.0_162)
* Browser or other details (if relevant)
* Webserver configuration (if relevant)

Providing this information really speeds up the ticket solving process.

### Provide information on how the issue can be reproduced ###

Try to provide steps or sample code that can reproduce the error. If necessary upload the files to the ticket. Please try to abstract out unnecessary code, or create sample code that can be used to help reproduce the issue.

Sample code provided should run out of the box with no need of any setup. 

If there's a Lucee setting involved or database tables necessary to create it, please attach a create table script or inform us what additional setting needs to be turned on / off.

Reduced [Trycf.com examples](https://trycf.com) are great, a reproducible bug is a solvable bug.

If you are familiar with TestBox, provide a [testcase](https://github.com/lucee/Lucee/tree/6.0/test).

### Provide workaround information ( if any ) ###

If you found a temporary workaround please provide the information. This can really help any other user that may have a similar issue. A workaround can also be analyzed as starting point for a possible solution.

### How to submit a patch ###

You can supply a patch to be analyzed to the Lucee development team. How can you do that?

* First, start a discussion on the mailing list
* Fork Lucee on GitHub
[https://github.com/lucee/Lucee](https://github.com/lucee/Lucee).
* Create an issue in JIRA
* Commit your patch and send a pull request. (ask on the mailing list first if you are unsure which branch to use)
* Post the link to your pull request in [JIRA](https://luceeserver.atlassian.net/) with as much details as possible so we can understand the issue.

### Lucee Website(s) Issues ###

If an error or issue pertains to the websites, please use the [contact form](https://lucee.org/contact.html)
