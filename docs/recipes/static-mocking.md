<!--
{
  "title": "Mocking Static Functions",
  "id": "static-mocking",
  "categories": ["testing"],
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

In Lucee, static functions belong to the **class** rather than an instance of a component. This means they can be called directly using the class name:

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
- Static functions can be dynamically **mocked per instance** without modifying the component.
- This allows for **cleaner test code** and avoids unnecessary duplication.

## The Benefit of Static Functions

1. **No Difference in Access** – Static functions work exactly like instance functions.
2. **Ease of Mocking** – Static functions can be mocked at the instance level, avoiding unnecessary wrappers.
3. **Consistency** – Static functions ensure a uniform implementation across instances while still allowing for instance-level customization when needed.
4. **Overlay vs. Overwrite** – When an instance function is redefined (mocked), it overwrites the original implementation for that instance. With static methods, defining an instance-level function of the same name overlays the static method for that instance only, while the original static method remains accessible via the class.

## Conclusion

Lucee’s handling of static functions provides a powerful way to structure shared functionality while maintaining flexibility in testing. Instead of introducing redundant instance function wrappers, developers can take advantage of the fact that static functions are accessible like instance functions and can be dynamically mocked per instance. This results in a cleaner, more maintainable codebase.

