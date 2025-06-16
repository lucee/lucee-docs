<!--
{
  "title": "getClass() Method for Components",
  "id": "component-getclass-method",
  "description": "This document explains the getClass() method for CFML components that implement Java interfaces, enabling seamless Java interoperability.",
  "keywords": [
    "getClass",
    "component",
    "java",
    "proxy",
    "interface",
    "interoperability"
  ],
  "related": [
    "tag-component",
    "function-createdynamicproxy",
    "new-operator",
    "developing-with-lucee-server"
  ],
  "categories": [
    "core",
    "component",
    "java"
  ]
}
-->

# getClass() Method for Components

In Lucee, components that implement Java interfaces can use the `getClass()` method to obtain the Java class representation. This method automatically creates (if needed) a dynamic proxy and returns the proxy's class, enabling seamless Java interoperability without explicit proxy creation.

*Available since Lucee 7.0*

## Basic Usage

When called on a component that implements Java interfaces, `getClass()` returns the Java class of the dynamic proxy:

```lucee
mymap = new component implements="java:java.util.Map" {
    // component implementation
};

classInfo = mymap.getClass(); // Returns proxy class
dump(classInfo);
```

This is equivalent to the more verbose:

```lucee
classInfo = createDynamicProxy(mymap).getClass();
```

## Method Resolution Order

The `getClass()` method follows a specific resolution order:

1. **Custom Function**: If the component defines a function named "getClass", that function is called
2. **Property Getter**: If the component has a property named "class" with `accessor=true`, the getter is used
3. **Default Behavior**: Otherwise, a dynamic proxy is created and `proxy.getClass()` is returned

## Requirements

- The component must implement at least one Java interface
- The method only applies to components, not regular objects

## Use Cases

This feature is particularly useful for:

- Java library integration where class information is needed
- Reflection operations on component proxies
- Framework development requiring class metadata
- Simplified Java interoperability code