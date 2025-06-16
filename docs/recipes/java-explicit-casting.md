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

# Java - Explicit Casting of a Component to a Specific Interface

This guide demonstrates how to explicitly cast a component to a specific interface in Lucee.

## Implicit Casting

Lucee supports implicit casting by passing a component to a method where the method argument is of a specific type. For example:

```lucee
cs = new component implementsJava="java.lang.CharSequence" {
  variables.text = "en_us";

  public function onMissingMethod(missingMethodName, missingMethodArguments) {
    if ("toString" == missingMethodName) return variables.text;
    else throw "method #missingMethodName# not supported yet!";
  }
};
// setLocale expects a String as argument PageContext.setLocale(java.lang.String)
getPageContext().setLocale(cs);
```

In this example, Lucee implicitly finds a matching method and converts the component to a class implementing the `java.lang.CharSequence` interface.

## Explicit Casting

Sometimes, implicit casting can be problematic if Lucee cannot make the correct fit, or if a method is overloaded and you need to specify which method to use. 

For instance, the `PageContext` class has two `setLocale` methods:

- `setLocale(java.lang.String): void`
- `setLocale(java.util.Locale): void`

To ensure the correct method is called, it is better to use explicit casting. Here's the modified example:

```lucee
cs = new component implementsJava="java.lang.CharSequence" {
  variables.text = "en_us";

  public function onMissingMethod(missingMethodName, missingMethodArguments) {
    if ("toString" == missingMethodName) return variables.text;
    else throw "method #missingMethodName# not supported yet!";
  }
};
// Explicitly cast to java.lang.CharSequence
obj = JavaCast("java.lang.CharSequence", cs);
dump(obj);

// Use the CharSequence object
getPageContext().setLocale(obj);
```

In this example, we first cast the component to `java.lang.CharSequence` (the base interface for `String`), then call `setLocale`. With this explicit casting, Lucee is able to link the correct method.
