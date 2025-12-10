<!--
{
  "title": "New Operator in Lucee",
  "id": "new-operator",
  "description": "This document provides a guide on using the new operator in Lucee for creating instances of CFML components and Java classes.",
  "keywords": [
    "new",
    "java",
    "classes",
    "class",
    "createObject",
    "component"
  ],
  "related": [
    "tag-component",
    "tag-import",
    "function-createobject",
    "developing-with-lucee-server"
  ],
  "categories": [
    "core",
    "component",
    "java"
  ]
}
-->

# New Operator

The `new` operator creates instances of CFML components (CFCs) and, since Lucee 6.2, Java classes directly. It's the modern alternative to `createObject()` - cleaner syntax and works the same way across both CFML and Java.

## CFML Components

Components are user-defined objects that encapsulate data and behavior. Use the full path, or import and use the short name:

```lucee
query = new org.lucee.cfml.Query(); // full path to Lucee core component
query = new Query(); // org.lucee.cfml is auto-imported
```

### Imports

```cfml
import org.lucee.extension.redis.RedisUtil;
import org.lucee.extension.quartz.*;

util = new RedisUtil();
cfc = new Quartz();
```

### Relative Paths

To reference a component in a folder above the calling template (where there's no mapping), use quotes and slashes:

```cfml
user = New "../model/User"(); // model folder is one level up
```

## Java Classes (6.2+)

Since Lucee 6.2, you can instantiate Java classes directly - useful for leveraging Java libraries without `createObject()`:

```lucee
sb = new java.lang.StringBuilder("Susi"); // full path to Java class
sb = new StringBuilder("Susi"); // java.lang is auto-imported
```

### Java Imports

```cfml
import lucee.runtime.type.StructImpl;
import java.util.*;

sct = new StructImpl();
map = new HashMap();
```

## Resolve Conflicts

When a class and component share the same name:

```cfml
quartzInterface = new java:Quarz(); // load class
quartzComponent = new cfml:Quarz(); // load component
```
