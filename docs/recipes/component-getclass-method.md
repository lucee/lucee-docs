<!--
{
  "title": "getClass() Method for Components",
  "id": "component-getclass-method",
  "since": "7.0",
  "description": "Get the Java class of a component that implements a Java interface.",
  "keywords": [
    "getClass",
    "component",
    "java",
    "interface"
  ],
  "related": [
    "tag-component",
    "function-createdynamicproxy"
  ],
  "categories": [
    "component",
    "java"
  ]
}
-->

# getClass() Method for Components

When a component implements a Java interface, you can call `getClass()` to get the underlying Java class. Useful when Java code needs to inspect your component's type.

**Java terms:** A *proxy* is a wrapper object that Lucee creates to make your component look like a real Java class. *Reflection* is when Java code inspects objects at runtime to discover their methods and properties - many frameworks use this for dependency injection, serialization, and type checking.

## Usage

```lucee
myMap = new component implements="java:java.util.Map" {
	// implement Map methods...
};

// Get the Java class
cls = myMap.getClass();
dump( cls.getName() ); // something like "lucee.runtime.proxy.Map$..."
```

This is shorthand for:

```lucee
cls = createDynamicProxy( myMap ).getClass();
```

## Resolution Order

1. If the component has a `getClass()` function, that's called
2. If the component has a `class` property with accessors, the getter is used
3. Otherwise, returns the Java proxy class

## Requirements

The component must implement at least one Java interface using `implements="java:..."` syntax.

## When You'd Use This

Some Java libraries inspect the class of objects you pass them - to check types, discover methods, or register handlers. Without `getClass()`, you'd need to manually create a proxy first. This makes it seamless.