<!--
{
  "title": "Using CFML Functions and Components in Java",
  "id": "convert-a-cfml-func-to-java",
  "description": "Pass CFML components and functions to Java code - implement Java interfaces with CFCs, use functions as Java lambdas.",
  "since": "6.0",
  "keywords": [
    "conversion",
    "cfc",
    "function",
    "component",
    "Java",
    "lambda",
    "Lucee"
  ],
  "categories": [
    "java"
  ],
  "related": [
    "tag-component",
    "dynamic-proxy-enhancements",
    "java-explicit-casting"
  ]
}
-->

# Using CFML Functions and Components in Java

Many Java libraries accept objects that implement specific *interfaces* - contracts defining what methods an object must have. Lucee lets you pass CFML components and functions directly to Java code.

**Java terms:** A *Java interface* defines method signatures a class must implement (like a blueprint). A *lambda* is a shorthand for a single-method interface - Java 8+ uses these heavily for callbacks and streaming APIs.

## Component to Java Interface

Implement the interface's methods in your component:

```lucee
// MyString.cfc - implements CharSequence interface
component {
	function init( String str ) {
		variables.str = reverse( arguments.str );
	}

	function length() {
		return str.length();
	}

	// ... implement other CharSequence methods
}
```

Then pass it to Java methods expecting that interface:

```lucee
HashUtil = createObject( "java", "lucee.commons.digest.HashUtil" );
cfc = new MyString( "Susi Sorglos" );

// HashUtil.create64BitHashAsString() expects CharSequence - Lucee converts automatically
hash = HashUtil.create64BitHashAsString( cfc );
dump( hash );
```

### Using implementsJava and onMissingMethod

Declare the interface explicitly and handle method calls dynamically:

```lucee
component implementsJava="java.util.List" {
	function onMissingMethod( name, args ) {
		if ( name == "size" ) return 10;
		throw "method #name# is not supported!";
	}
}
```

See [[java-explicit-casting]] for when you need to cast components to specific interfaces.

## Functions as Java Lambdas

When a Java method expects a *functional interface* (an interface with one method), you can pass a CFML function directly. Lucee converts it automatically:

```lucee
numeric function doubleIt( numeric i ) {
	return i * 2;
}

// Java's IntStream.map() expects IntUnaryOperator (one method: int applyAsInt(int))
import java.util.stream.IntStream;
result = IntStream::of( 1, 2, 3 ).map( doubleIt ).sum();
dump( result ); // 12 (2 + 4 + 6)
```

See [[java-in-functions-and-closures]] for more on Java lambdas and the `type="java"` function attribute.
