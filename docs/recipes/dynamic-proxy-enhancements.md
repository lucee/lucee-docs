<!--
{
  "title": "Dynamic Proxy Enhancements in Lucee 7",
  "id": "dynamic-proxy-enhancements",
  "description": "Learn about the improvements to dynamic proxy creation in Lucee 7, including automatic inclusion of component functions and properties when implementing Java interfaces.",
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

# Dynamic Proxy Enhancements in Lucee 7

Lucee 7 introduces significant improvements to dynamic proxy creation, making Java interoperability more seamless and predictable when components implement Java interfaces.

## What Changed in Lucee 7

### Component Functions and Properties Always Included

In previous versions, when creating a dynamic proxy from a component that implements Java interfaces, not all component functions and properties were consistently included in the proxy. Lucee 7 ensures that **all component functions and properties are always included** in the dynamic proxy.

This enhancement (LDEV-5421) makes dynamic proxies behave more predictably and eliminates subtle issues where component methods might not be accessible through the proxy.

## Basic Usage

When you create a component that implements a Java interface, you can use `createDynamicProxy()` to get a Java proxy object:

```cfml
// Define a component implementing java.util.Map
myComponent = new component implements="java:java.util.Map" {

	function size(){
		return 42;
	}

	function isEmpty(){
		return false;
	}

	// Custom function (not part of Map interface)
	function customMethod(){
		return "This is now always included in the proxy!";
	}

	// Additional required Map methods...
	function get( key ){
		return "value";
	}

	function put( key, value ){
		return null;
	}

	// ... other Map interface methods
};

// Create the dynamic proxy
proxy = createDynamicProxy( myComponent, [ "java.util.Map" ] );

// All component methods are accessible through the proxy
systemOutput( proxy.size() );	// 42
systemOutput( proxy.customMethod() );	// Works in Lucee 7!
```

## Automatic Proxy Creation with getClass()

Lucee 7 also introduces the ability to call `.getClass()` directly on components that implement Java interfaces, automatically creating a dynamic proxy if needed:

```cfml
myComponent = new component implements="java:java.util.Map" {
	function size(){
		return 42;
	}
	// ... other methods
};

// New in Lucee 7 - automatic proxy creation
classInfo = myComponent.getClass();

// Previously required explicit proxy creation:
// classInfo = createDynamicProxy( myComponent, [ "java.util.Map" ] ).getClass();
```

See [[component-getclass-method]] for more details on this feature.

## Use Cases

These enhancements are particularly valuable when:

- **Building Java library integrations** - Your component methods are reliably accessible through the proxy
- **Extending Java interfaces** - Add custom functionality beyond the interface contract
- **Framework development** - Create components that implement Java interfaces with additional CFML-specific methods
- **Working with callbacks** - Pass components to Java libraries that expect interface implementations

## Example: Implementing java.lang.Runnable

```cfml
// Create a component implementing Runnable
task = new component implements="java:java.lang.Runnable" {

	variables.executionCount = 0;

	function run(){
		variables.executionCount++;
		systemOutput( "Task executed ##variables.executionCount## times" );
	}

	// Custom method to check execution count
	function getExecutionCount(){
		return variables.executionCount;
	}
};

// Create proxy and pass to Java's ExecutorService
proxy = createDynamicProxy( task, [ "java.lang.Runnable" ] );

// Create a Java thread
thread = createObject( "java", "java.lang.Thread" ).init( proxy );
thread.start();
thread.join();

// Access custom methods through the original component
systemOutput( "Total executions: " & task.getExecutionCount() );
```

## Key Benefits

1. **Predictable behavior** - All component methods are consistently available through the proxy
2. **Simplified code** - Automatic proxy creation with `.getClass()`
3. **Better Java integration** - Seamlessly mix CFML and Java functionality
4. **Enhanced flexibility** - Add custom methods beyond interface requirements

## See Also

- [[component-getclass-method]] - Using getClass() for automatic proxy creation
- [[java-class-interaction]] - General Java interoperability in Lucee
- [[function-createdynamicproxy]] - createDynamicProxy() function reference
