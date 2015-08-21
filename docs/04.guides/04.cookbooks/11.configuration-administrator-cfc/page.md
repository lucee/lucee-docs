---
title: Configure Lucee within your Application
id: cookbook-configuration-administrator-cfc
---

# Configure Lucee within your application #
Lucee is providing a web frontend to configure the complete server and every single web context, but you can also do this configuration from within your application
(For per request settings, please check out the" Application.cfc" Section in the [Cookbook](Cookbook)).


## Administrator.cfc ##
Lucee is providing the component "Administrator.cfc" in the package "org.lucee.cfml" a package auto imported in any template, so you can simply use that component as follows


```
#!javascript
admin=new Administrator("web","myPassword"); // first argument is the admin type you wanna load (web|server), second the password for the Administrator
dump(admin); // show me the doc for the component
admin.updateCharset(resourceCharset:"UTF-8"); // set the resource charset

```

## cfadmin Tag ##
The component "Administrator" is far from being feature complete, so if you miss a functionality, best consult the unofficial tag "cfadmin" (undocumented) and check out how this tag is used inside the [Lucee Administrator](https://bitbucket.org/lucee/lucee/src/baec0ab812123a904f5342a5f7362bc6c129fac2/lucee-cfml/lucee-admin/?at=master).
Of course, it would be great if you could contribute your addition to the "Administrator" component.
