---
title: CreateObject
id: function-createobject
categories:
- component
- java
- object
- webservice
description: 'The CreateObject function takes different arguments depending on the
  value of the first argument:'
---

The CreateObject function takes different arguments depending on the value of the first argument:

```luceescript
CreateObject('com', class, context, serverName)
CreateObject('component', component-name)
CreateObject('corba', context, class, locale)
CreateObject('java', class [, context])
CreateObject('webservice', urltowsdl, [, portname])
```

>>>> In Lucee 5, this function has been [[deprecated|deprecated]] in favour of the `new object()` syntax (reference needed). The only difference is that the `new Object()` syntax automatically calls the `init()` method. In line with our [commitment to CFML](https://lucee.org/blog/the-lucee-language.html), this function will never be dropped from the language and you are safe to use it going forward.
