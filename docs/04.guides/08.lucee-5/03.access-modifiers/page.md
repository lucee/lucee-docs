---
title: Access Modifiers for variables
id: lucee-5-access=modifiers
---

#Access Modifiers for variables#
**Lucee already supports access modifiers for functions, but with Lucee 4 this was limited to functions, Lucee 5 now also supports access modifiers for variables.**

Access modifiers can be defined for all variables defined within the body of a component, for example:

```luceescript
component {
   private this.lastName="Sorglos"; // cannot be accessed from outside
   public this.comment="This is a comment"; // can be accessed from outside
   ...
}

```
