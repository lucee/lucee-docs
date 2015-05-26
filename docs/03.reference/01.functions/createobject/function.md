---
title: CreateObject
id: function-createobject
related:
categories:
---

>>>> In Lucee 5, this function has been deprecated in favour of [[function-new]] (see [[working-with-objects]]). Inline with our [committment to CFML](http://lucee.org/blog/the-lucee-language.html), this function will never be dropped from the language and you are safe to use it going forward.

The CreateObject function takes different arguments depending on the value of the first argument:

        CreateObject('com', class, context, serverName)
        CreateObject('component', component-name)
        CreateObject('corba', context, class, locale)
        CreateObject('java', class)
        CreateObject('webservice', urltowsdl, [, portname])