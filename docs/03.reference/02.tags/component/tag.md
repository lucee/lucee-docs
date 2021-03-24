---
title: <cfcomponent>
id: tag-component
related:
- tag-function
- tag-interface
- tag-invoke
- tag-invokeargument
- tag-object
- tag-property
categories:
- component
- core
description: Creates and defines a component object
---

Creates and defines a component object; encloses functionality that you build in CFML and enclose within [[tag-function]] tags.

This tag contains one or more cffunction tags that define methods.

Code within the body of this tag, other than cffunction tags, is executed when the component is instantiated.
