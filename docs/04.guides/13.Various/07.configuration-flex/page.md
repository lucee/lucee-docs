---
title: Configuration:Flex_configuration
id: configuration-flex
---

## Preventing the Flex integration in Lucee to create unnecessary WEB-INF directories ##

For the flex configuration there are some files that are necessary for each web context. They are usually generated inside the webroot in a folder called WEB-INF/flex. Up until Lucee version 3.3 there was no possibility of changing this directory. It should be possible to use Lucee without Flex and therefore it would be good if one can get rid of this directory. The way to do this is to edit the file lucee-[web|server].xml[.cfm] and define the following inside the tag flex:

```lucee
xml = auto-deploy the configutation as xml (default)
manual = no deployment at all, user has to add the configuration manually
```