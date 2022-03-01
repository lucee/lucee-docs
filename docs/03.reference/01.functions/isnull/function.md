---
title: IsNull
id: function-isnull
related:
- function-nullvalue
categories:
- decision
description: Determines whether given object is null or not
---

Determines whether given object is null or not.

**IMPORTANT** — When testing the presence of `null` values unscoped variables will use scope precedence to determine if the variable exists in any scope. This behavior differs from Adobe ColdFusion. So when testing when local variables in a function are `null`, it’s important to prefix the variable with the `local` scope. 

For example, in the following code the variable `name` would return `false` for the `isNull()` if `name` ends up in a user supplied scope, such as the `URL` or `FORM` scopes:

```
function getName(){
  var name = nullValue();  
  return isNull(name) ? "is null" : "is not null";
}
```

In order to make sure that only the local `name` variable is checked, you would change the code to:

```
function getName(){
  var name = nullValue();  
  return isNull(local.name) ? "is null" : "is not null";
}
```
