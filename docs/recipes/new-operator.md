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
    "function-createobject",
    "developing-with-lucee-server"
  ],
  "categories": [
    "core"
  ]
}
-->

# New Operator in Lucee

In Lucee, the `new` operator is primarily used to create instances of CFML components (CFCs). However, starting from Lucee 6.2, the `new` operator can also be used to instantiate Java classes directly. This enhancement bridges the gap between CFML and Java, allowing more seamless integration between the two.

## CFML Components

CFML components are user-defined objects in Lucee that encapsulate data and behavior. Using the `new` operator, you can create an instance of a component, either by specifying the full path or by using an implicit or typed approach.

### Example

The following test cases demonstrate the use of the `new` operator with CFML components:

```lucee
query = new org.lucee.cfml.Query(); // load component provided by Lucee core
query = new Query(); // org.lucee.cfml package always is imported automatically

```

Importing components:

```cfml
import org.lucee.extension.redis.RedisUtil; // import single component
import org.lucee.extension.quartz.*; // import a complete package

RedisUtil = new RedisUtil(); // load component defined with import
cfc = new Quartz(); // load component from a package imported

```

## Java Classes

Starting from Lucee 6.2, you can use the `new` operator to instantiate Java classes directly, similar to how you would in Java itself. This is particularly useful when you want to leverage Java libraries or classes within your CFML code without relying on `createObject`.

### Example

The following test cases demonstrate the use of the `new` operator with Java classes:

```lucee
sb = new java.lang.StringBuilder("Susi"); // load a class from the Java core library
sb = new StringBuilder("Susi"); // java.lang package always is imported automatically
		
```

Importing classes:

```cfml
import lucee.runtime.type.StructImpl; // import single class
import java.util.*; // import a complete package

sct = new StructImpl(); // load class defined with import
map = new HashMap(); // load a class from a package imported

```

## Avoid conflicts

What if you wanna Load a class that also exist as a component or the other way around? In that case you can simply define the type needed explicitly like this

```cfml
quartzInterface = new java:Quarz(); // load class
quartzComponent = new cfml:Quarz(); // load component

```
