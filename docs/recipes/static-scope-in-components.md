<!--
{
  "title": "Static Scope in Components",
  "id": "static-scope-in-components",
  "categories": [
    "component",
    "scopes",
    "static"
  ],
  "description": "Understanding the static scope in Lucee components and how it can be used for shared data and functions.",
  "keywords": [
    "Static scope",
    "Components",
    "Lucee",
    "Application scope",
    "Server scope",
    "GetComponentMetaData"
  ]
}
-->

# Static Scope in Components

Static variables and functions belong to the component itself, not to individual instances. Use them for shared state (counters, caches, config) or utility functions that don't need instance data.

Call static members with `::` syntax: `MyComponent::myStaticFunction()`.

## Static Variables

Shared across all instances and persist for the application lifetime:

```cfml
component {
	static {
		counter = 0;
	}

	public function init() {
		static.counter++;
		dump( "Instance ##" & static.counter );
	}

	public function getCount() {
		return static.counter;
	}
}
```

Every `new Counter()` increments the same counter.

## Static Functions

Call directly on the component without creating an instance:

```cfml
// Greeter.cfc
component {
	public static function hello( name ) {
		return "Hello, " & name & "!";
	}
}

// Usage - no instantiation needed
message = Greeter::hello( "World" );
```

## Static vs Instance

```cfml
component {
	public static function utility() {
		return "I don't need instance data";
	}

	public function process() {
		return "I can access this and variables scope";
	}
}
```

Static functions can also be called on instances (same result):

```cfml
obj = new Example();
dump( obj.utility() );      // works
dump( Example::utility() ); // same thing
```

## Mocking Static Functions

You can override a static function on an instance for testing without affecting the component:

```cfml
obj = new Example();
obj.utility = function() {
	return "Mocked!";
};

dump( Example::utility() ); // "I don't need instance data" (original)
dump( obj.utility() );      // "Mocked!" (instance override)
```

## When to Use Static

- **Utility functions** - helpers that don't need instance state
- **Shared counters/caches** - track across all instances
- **Constants** - values that don't change
- **Factory methods** - alternative constructors
