---
title: Application.cfc settings
id: tag-application
---

Defines a CFML application and various properties of that application: name, datasource, timeouts, client variable settings, session settings and more. By default, client variables are disabled, and session and application variables are stored in memory.

These settings can also be set in an Application.cfc as this properties. i.e. 

```

this.name = "myApplication";
this.ormsettings.autogenmap = false;

```
