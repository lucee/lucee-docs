---
title: Tutorial Reporting_Bugs
id: tutorial-reporting-bugs
---

### How to report a bug in Lucee ###

First, thank you for evaluating Lucee and taking the time to report issues. The Lucee Team cannot stress how important it is to have an active open source community and reporting issues is one of the many ways in which you can participate and be involved. Since Lucee project is open source and part of the JBoss community, we use their JIRA Issue Tracker which can be found here: 
[https://jira.jboss.org/browse/RAILO](https://jira.jboss.org/browse/RAILO).

### Give tickets a self-explanatory title and context ###

A detailed ticket is really helpful when a long list of tickets is analyzed. If the title is phrased properly it is easier for the developer to understand what the issue is about, and probably link it to some changes that is in progress or that has been done recently. Try to give a context to the ticket. A ticket title like createTimeSpan fails doesn't give us much context to work with, but createTimeSpan fails when invoked into a script based cfc does.

### Provide environment information ###

When a bug is posted the first thing we do is to try to reproduce it. It is very important to have information about the environment where the issue was detected.

* OS
* Lucee Deployment ( Ex : tomcat as war, Resin default installer )
* Browser or other details if relevant.

Providing this information really speeds up the ticket solving process.

### Provide information on how the issue can be reproduced ###

Try to provide steps or sample code that can reproduce the error. If necessary upload the files to the ticket. Please try to abstract out unnecessary code, or create sample code that can be used to help reproduce the issue. Sample code provided should run out of the box with no need of any setup. If there's a Lucee setting involved or database tables necessary to create it, please attach a create table script or inform us what additional setting needs to be turned on / off.

### Provide workaround information ( if any ) ###

If you found a temporary workaround please provide the information. This can really help any other user that may have a similar issue. A workaround can also be analyzed as starting point for a possible solution.

### How to submit a patch ###

You can supply a patch to be analyzed to the Lucee development team. How can you do that?

* Fork the railo project at ([https://github.com/getrailo/railo](http://github.com/getrailo/railo)). Apply your patch and send a pull request. ( preferred )
* Add the patch directly to the JIRA with as much details as possible so we can understand the issue.

### Lucee Website(s) Issues ###

If an error or issue pertains to the websites
[getrailo.org](http://getrailo.org/) or
[getrailo.com](http://getrailo.com/),
[please contact](http://www.getrailo.org/index.cfm/contact-us/) us directly.
