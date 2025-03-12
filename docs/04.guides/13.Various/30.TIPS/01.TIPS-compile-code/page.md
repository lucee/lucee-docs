---
title: How to compile CFM/CFCs
id: tips-compilecode
---

## How do I compile my CFM/CFCs? ##

1. Create a mapping that is called "/" and that points to "/".
1. Then edit the mapping and click on the compile button (untick the stop on errors box).
1. Then you'll find the compiled classes in the folder:	```/WEB-INF/lucee/cfclasses/yourappropiatemappingname/```

	Return to [[faq-s]] or [[tips-and-tricks]]

## CommandBox ##

You can also leverage CommandBox along with [cfml-compiler](https://www.forgebox.io/view/cfml-compiler/version/1.0.6)

```
box cfcompile sourcePath=./src destPath=./compiled cfengine=lucee@6
```
