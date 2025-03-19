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

## Understanding Static Scope

The **static scope** in Lucee components allows variables and functions to be shared across all instances of a component. This avoids the need to create a new instance every time a function is called, improving efficiency and consistency.

Static scope was introduced in Lucee 5.0 and provides a way to store shared state at the component level rather than per instance.

## Defining Static Variables

A static variable is shared among all instances of a component and retains its value across multiple calls:

```
component {
    static var counter = 0;
    
    public function init() {
        static.counter++;
        dump("Instance created: " & static.counter);
    }
    
    public function getCount() {
        return static.counter;
    }
}
```

When multiple instances of this component are created, the `counter` variable is incremented across all instances:

```
new Example();
new Example();
new Example();
```

Each instance shares the same `counter` value, demonstrating the persistent nature of static variables.

## Using Static Functions

A static function can be called directly on the component itself, without needing an instance:

```
component {
    public static function hello() {
        return "Hello, World!";
    }
}
```

Calling a static function without instantiating the component:

```
dump(Example::hello());
```

## Static Functions vs. Instance Functions

- **Instance Functions**: Defined without `static` and tied to an object instance.
- **Static Functions**: Defined with `static` and shared across all instances.

Example:

```
component {
    public static function staticFunction() {
        return "I am static";
    }
    
    public function instanceFunction() {
        return "I am an instance function";
    }
}
```

Usage:

```
obj = new Example();
dump(obj.instanceFunction()); // Works only on an instance

dump(Example::staticFunction()); // Works without an instance
```

## Accessing Static Functions via Instances

Lucee allows static functions to be accessed the same way as instance functions:

```
obj = new Example();
dump(obj.staticFunction()); // Outputs: "I am static"
```

This means static functions do not require special handling and can be called via a component instance or the component definition itself.

## Mocking Static Functions

A key advantage of Lucee’s implementation is that **static functions can be accessed just like instance functions** and **can be mocked per instance**:

```
obj = new Example();
obj.staticFunction = function() {
    return "Mocked static function";
};

dump(Example::staticFunction()); // Outputs: "I am static"
dump(obj.staticFunction()); // Outputs: "Mocked static function"
```

This means:

- Static functions can be dynamically modified per instance without affecting the original component definition.
- No need for redundant instance wrappers for testing.

## Benefits of Static Scope

1. **Performance Optimization** – Avoids redundant instantiations.
2. **Shared State** – Useful for counters, caching, and global configurations.
3. **Mocking Flexibility** – Allows instance-level modifications for testing while keeping the original static function intact.
4. **Overlay vs. Overwrite** – When an instance function is redefined, it **overwrites** the original implementation for that instance. With static functions, defining an instance-level function of the same name **overlays** the static function for that instance only, while the original static function remains accessible via the component definition.

## Conclusion

Static scope in Lucee enables shared variables and functions across instances, improving efficiency and making testing more flexible. By understanding how to use static variables, functions, and mocking techniques, developers can write cleaner, more maintainable code.
