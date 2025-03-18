<!--
{
  "title": "Mocking Static Functions",
  "id": "mocking-static-functions-lucee",
  "categories": ["lucee", "testing"],
  "description": "How to mock static functions in Lucee for better testability without unnecessary wrappers.",
  "keywords": [
    "Static Functions",
    "Mocking",
    "Unit Testing"
  ]
}
-->

# Mocking Static Functions in Lucee

## Understanding Static Functions in Lucee

In Lucee, static functions belong to the **component definition** rather than a specific component instance. This means they can be called directly using the component name:

```
// Test.cfc
component {
    public static function myStaticFunction() {
        return "static";
    }
}
```

Calling the static function:

```
dump(Test::myStaticFunction()); // Outputs: "static"
```

Unlike instance functions, static functions:
- Do not require an object instance to be called.
- Are shared across all instances of the component.
- Can be accessed **exactly like instance functions**.

## Accessing Static Functions via Instances

In Lucee, a static function can **also** be accessed through an instance of the component, just like an instance function:

```
testInstance = new Test();
dump(testInstance.myStaticFunction()); // Outputs: "static"
```

## Mocking Static Functions

One key advantage of this behavior is that **static functions can be mocked just like instance functions**.

Example:

```
testInstance = new Test();
// overlay static function with diffrent behaviour
testInstance.myStaticFunction = function() {
    return "mockstatic";
};

dump(Test::myStaticFunction());      // Outputs: "static"
dump(testInstance.myStaticFunction()); // Outputs: "mockstatic"
```

### Why This Matters for Testing
- There is **no need** to create instance wrapper functions for static functions.
- Static functions can be dynamically **mocked per instance** without modifying the component.
- This allows for **cleaner test code** and avoids unnecessary duplication.

## Retrieving Static and Instance Function Metadata

Lucee provides a way to retrieve metadata for both static and instance functions using `getMetadata`. The structure of the returned metadata is identical for both, with the only difference being a `static` flag:

```
testInstance = new Test();
dump(getMetadata(testInstance).functions);
```

Example output:

```
[
    {"name": "myInstanceFunction", "static": false,...},
    {"name": "myStaticFunction", "static": true,...}
]
```

This means that **static and instance functions are represented the same way in metadata**, with the `static` flag indicating whether a function is static or not.

## The Benefit of Static Functions

1. **No Difference in Access** – Static functions work exactly like instance functions.
2. **Ease of Mocking** – Static functions can be mocked at the instance level, avoiding unnecessary wrappers.
3. **Consistency** – Static functions ensure a uniform implementation across instances while still allowing for instance-level customization when needed.
4. **Overlay vs. Overwrite** – When an instance function is redefined (mocked), it **overwrites** the original implementation for that instance. With static functions, defining an instance-level function of the same name **overlays** the static function for that instance only, while the original static function remains accessible via the component definition.

## Conclusion

Lucee’s handling of static functions provides a powerful way to structure shared functionality while maintaining flexibility in testing. Instead of introducing redundant instance function wrappers, developers can take advantage of the fact that static functions are accessible like instance functions and can be dynamically mocked per instance. Additionally, `getMetadata` provides an easy way to differentiate between static and instance functions, reinforcing the consistent handling of both in Lucee.

