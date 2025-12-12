---
title: <cfimport>
id: tag-import
related:
- function-createobject
- function-mavenload
- java-class-interaction
- java-settings
categories:
- java
---

The tag `import` has multiple purposes:

1. Import components with the attribute `path`
2. Import Java classes (Lucee 6.2+) with the attribute `path` or its alias `java` 
3. Import CFML/JSP custom tags with the attributes `prefix` and `taglib`

In script syntax, you can use:

- `cfimport(path="org.lucee.example.MyCFC");` 
- `import org.lucee.example.MyCFC;` 
- `import "org.lucee.example.MyCFC";`

For importing multiple components, use the wildcard syntax:

- `import "org.lucee.example.*";`

For Java classes (Lucee 6.2+), the classpath is shared between components and Java classes.

By default, Lucee first looks for cfml components and then for Java classes if not found.

**Important:** `import` only controls **naming** (letting you use short class names). It does not control **which JAR or version** is loaded. If you need a specific library version - especially when it conflicts with Lucee's bundled libraries - use `javasettings` to specify the dependency. See [[java-class-interaction]] for details.

Optionally, you can explicitly specify the type:

- `import java:java.util.HashMap;`
- `import cfml:org.lucee.cfml.Query;`

Note: Imports only affect the current template, not the entire request.

Reference: [[import]]
