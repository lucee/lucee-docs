---
title: Abstract/Final Modifiers
id: lucee-5-abstract-final
---

# Abstract/Final components/functions #

**Whilst Lucee already supports interfaces, interfaces are not well adopted in the developer community because they are only used to do "sign a contract" when you implement them. Abstract and Final modifiers are a much more intuitive and flexible way to do the same and more.**

## Abstract

Abstract component / functions cannot be used directly, you can only extend them.

### AContext.cfc

```luceescript
abstract component {
    abstract function getFile();

    final function getDirectory() {
        return getDirectoryFromPath(getFile());
    }
}
```

It is not possible to create an instance of this component (e.g. new AContext()), because this component has been defined as abstract. You can only "extend" this component (e.g. component extends="AContext" {}). This is therefore like an interface but it contains working code.

As you can see, we can define a generic method in the "abstract" component, so every component that is extending this component needs to implement this method or has to be an "abstract" component itself.

Only "abstract" components can contain "abstract" functions.

## Final

The "final" modifier is the opposite to the "abstract" modifier and means you can not extend a component / function. This would be used when you do not want to allow code to override your component or function.

Unlike "abstract" a function can be "final" even if the component is not "final".

### Context.cfc

```luceescript
final component extends="AContext" {
    function getFile() {
        return getCurrentTemplatePath();
    }
}
```
Here we are extending the component "AContext" from above and implementing the required "getFile" function.

In contrast to "abstract", a "final" method also can be defined in a non-final component.

```luceescript
component  {
   final function getFile() {
      return getCurrentTemplatePath();
   }
}
```

## Tag syntax

Modifiers can also be used within tags, for example:

```lucee
<cfcomponent modifier="abstract">
   <cffunction name="time" modifier="final">
      <cfreturn now()>
   </cffunction>
</cfcomponent>
```
