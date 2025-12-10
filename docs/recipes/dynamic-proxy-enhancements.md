<!--
{
  "title": "Dynamic Proxy Enhancements",
  "id": "dynamic-proxy-enhancements",
  "since": "7.0",
  "description": "Lucee 7 improvements to dynamic proxy creation - all component functions and properties are now always included when implementing Java interfaces.",
  "keywords": [
    "dynamic proxy",
    "java",
    "interface",
    "component",
    "interoperability",
    "createDynamicProxy"
  ],
  "related": [
    "component-getclass-method",
    "java-class-interaction",
    "function-createdynamicproxy",
    "tag-component"
  ],
  "categories": [
    "java",
    "component"
  ]
}
-->

# Dynamic Proxy Enhancements

When you pass a CFML component to Java code, Lucee creates a *proxy* - a wrapper that makes your component look like a Java object. In Lucee 7, proxies now include **all** your component's functions and properties, not just the interface methods.

**Java terms:** A *Java interface* is a contract defining method signatures a class must implement (like CFML's `implements` attribute). A *proxy* wraps your component so Java sees it as implementing that interface.

## What Changed

Previously, custom methods you added beyond the interface weren't consistently available through the proxy. Now they always are (LDEV-5421).

## Example

```cfml
myComponent = new component implements="java:java.util.Map" {
	function size() { return 42; }
	function isEmpty() { return false; }
	function get( key ) { return "value"; }
	function put( key, value ) { return null; }
	// ... other Map methods

	// Custom function (not part of Map interface)
	function customMethod() {
		return "Now always included in the proxy!";
	}
};

proxy = createDynamicProxy( myComponent, [ "java.util.Map" ] );

systemOutput( proxy.size() );          // 42
systemOutput( proxy.customMethod() );  // Works in Lucee 7!
```

## getClass() Shorthand

Components with `implements="java:..."` can call `.getClass()` directly - Lucee creates the proxy automatically:

```cfml
myComponent = new component implements="java:java.util.Map" {
	// ... methods
};

classInfo = myComponent.getClass();

// Equivalent to:
// classInfo = createDynamicProxy( myComponent, [ "java.util.Map" ] ).getClass();
```

See [[component-getclass-method]] for details.

## Runnable Example

A practical use case - implementing Java's `Runnable` interface to run code in a thread:

```cfml
task = new component implements="java:java.lang.Runnable" {
	variables.executionCount = 0;

	function run() {
		variables.executionCount++;
		systemOutput( "Task executed ##variables.executionCount## times" );
	}

	// Custom method - now accessible through proxy
	function getExecutionCount() {
		return variables.executionCount;
	}
};

proxy = createDynamicProxy( task, [ "java.lang.Runnable" ] );

thread = createObject( "java", "java.lang.Thread" ).init( proxy );
thread.start();
thread.join();

systemOutput( "Total executions: " & task.getExecutionCount() );
```

## When You'd Use This

- **Java library callbacks** - pass components to Java code expecting interface implementations
- **Custom methods on proxies** - add CFML-specific helpers alongside interface methods
- **Threading** - implement Runnable, Callable, or other Java concurrency interfaces
