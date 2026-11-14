<!--
{
  "title": "Java - Explicit Casting of a Component to a Specific Interface",
  "id": "java-explicit-casting",
  "since": "6.0",
  "categories": [
    "java"
  ],
  "description": "Shows how to explicitly cast a component to a specific interface.",
  "keywords": [
    "java",
    "cast",
    "convert",
    "method"
  ],
  "related": [
    "function-javacast",
    "tag-component"
  ]
}
-->

# Casting Components to Java Interfaces

When you pass a CFML component to Java code, Lucee needs to convert it to a Java type. Usually this happens automatically, but sometimes you need to tell Lucee exactly which Java interface to use - especially when Java methods have multiple versions that accept different types.

## The Problem: Overloaded Methods

Java allows multiple methods with the same name but different parameter types (called "overloading"). For example, `setLocale()` might accept either a `String` or a `Locale` object. When Lucee can't determine which version to call, you get errors or unexpected behavior.

## How Components Implement Java Interfaces

The `implementsJava` attribute tells Lucee your component should be treated as a Java interface. You implement the interface methods using `onMissingMethod` - when Java calls a method on your component, this function handles it:

```lucee
// Component that implements Java's CharSequence interface
cs = new component implementsJava="java.lang.CharSequence" {
	variables.text = "en_us";

	// Handle calls from Java code
	public function onMissingMethod( missingMethodName, missingMethodArguments ) {
		if ( missingMethodName == "toString" ) return variables.text;
		throw "method #missingMethodName# not supported yet!";
	}
};

// Pass to Java - Lucee figures out it implements CharSequence
getPageContext().setLocale( cs );
```

This works because Lucee automatically converts the component to match what Java expects.

## When You Need Explicit Casting

The automatic conversion fails when Java has multiple methods with the same name. `PageContext.setLocale()` has two versions:

- `setLocale( java.lang.String )`
- `setLocale( java.util.Locale )`

Lucee doesn't know which one you want. Use `JavaCast()` to be explicit:

```lucee
cs = new component implementsJava="java.lang.CharSequence" {
	variables.text = "en_us";

	public function onMissingMethod( missingMethodName, missingMethodArguments ) {
		if ( missingMethodName == "toString" ) return variables.text;
		throw "method #missingMethodName# not supported yet!";
	}
};

// Explicitly cast to CharSequence (the base interface for String)
obj = JavaCast( "java.lang.CharSequence", cs );

// Now Lucee knows to use the String version of setLocale()
getPageContext().setLocale( obj );
```

## When to Use This

This is advanced Java integration - you'll typically need it when:

- Passing CFML components to Java libraries that expect specific interfaces
- Working with Java APIs that have overloaded methods
- Implementing Java callbacks or listeners in CFML
