---
title: Application.cfc / <cfapplication>
id: tag-application
categories:
- application
- core
- scopes
- session
description: Defines a CFML Application and configures the properties / behavior of that Application
---

Defines a CFML Application and configures the properties / behavior of that Application:

- name
- datasources
- timeouts
- client variable settings
- session settings
- cookies
- and more!

By default, client variables are disabled, and Session and Application variables are stored in memory.

All these settings below can also be configured using the Modern `Application.cfc` approach, see [[cookbook-application-context-basic]].

These properties can be configured in the `Application.cfc` constructor

i.e.

```
this.name = "myApplication";
this.ormsettings.autogenmap = false;

// you can also configure your own custom tag attributes defaults, see [[tags]]
// i.e. this overrides the default log file of "application.log"
// instead this application will write out all default logs to a log file
// named after the Application ( i.e. 'myApplication.log')

this.tag.log.log = this.name & ".log";
```
