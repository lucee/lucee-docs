<!--
{
  "title": "Java in Functions and Closures, function() type='java'",
  "id": "java-in-functions-and-closures",
  "since": "6.0",
  "description": "Learn how to write CFML code directly in a function or a closure with Java types in Lucee. This guide demonstrates how to define functions and components with Java types, and how to use Java lambda functions within Lucee. You will see examples of how to handle exceptions, define return types, and implement functional Java interfaces (Lambdas) seamlessly.",
  "keywords": [
    "function",
    "java",
    "closures",
    "components",
    "lambda",
    "Lucee"
  ],
  "categories": [
    "java"
  ],
  "related": [
    "tag-function"
  ]
}
-->

# Java in Functions and Closures

Sometimes you need raw Java performance or want to use Java APIs that don't translate well to CFML. With `type="java"` you can write actual Java code inside a CFML function - the function body is compiled as Java, not CFML.

This is useful for:

- Performance-critical code (Java compiles to optimized bytecode)
- Implementing Java functional interfaces (lambdas) to pass to Java libraries
- Using Java syntax you're already familiar with

**Note:** Without a JDK, Lucee uses the [Janino compiler](https://janino-compiler.github.io/janino/) which has some [limitations](https://janino-compiler.github.io/janino/#limitations).

## Basic Syntax

Add `type="java"` to any function. The return type and arguments must use Java types (`int`, `String`, `boolean`, etc.), not CFML types:

```lucee
// Java types: int, not numeric; String, not string
int function doubleIt( int i ) type="java" {
	return i * 2;
}

dump( doubleIt( 5 ) ); // 10
```

Java exceptions work too:

```lucee
int function safeDouble( int i ) type="java" {
	if ( i < 0 ) throw new IllegalArgumentException( "Must be positive" );
	return i * 2;
}
```

## In Components

Works the same in CFCs - mix Java and CFML functions freely:

```lucee
component {
	// Java function
	int function multiply( int a, int b ) type="java" {
		return a * b;
	}

	// Regular CFML function
	function describe( required numeric value ) {
		return "The value is #value#";
	}
}
```

## Java Lambda Functions (Functional Interfaces)

Java 8+ uses "functional interfaces" (interfaces with one method) for lambdas. When your Java function signature matches a functional interface, Lucee can pass it directly to Java code expecting that interface.

Example: Java's `IntUnaryOperator` is a functional interface with method `int applyAsInt(int)`. A matching CFML function:

```lucee
// Matches IntUnaryOperator: takes int, returns int
int function triple( int i ) type="java" {
	return i * 3;
}

// Can now pass to Java methods expecting IntUnaryOperator
import java.util.stream.IntStream;
result = IntStream::of( 1, 2, 3 ).map( triple ).sum();
dump( result ); // 18 (3 + 6 + 9)
```

This lets you use CFML functions with Java's Stream API, CompletableFuture, and other functional Java APIs.
