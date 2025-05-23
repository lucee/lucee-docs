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

You can write CFML code directly in a function or a closure.

If you aren't running Lucee with a JDK, Lucee falls back on the [Janino compiler](https://janino-compiler.github.io/janino/) to compile your java code, so any [limitations](https://janino-compiler.github.io/janino/#limitations) of Janino apply.

## Functions

Inside the function, you can write regular Java code. The arguments and return type definition must be Java types.

```lucee
int function echoInt(int i) type="java" {
    if (i == 1) throw new Exception("Upsi dupsi!!!");
    return i * 2;
}
```

## Components

Of course, the function can also be part of a component.

```lucee
component {
    int function echoInt(int i) type="java" {
        if (i == 1) throw new Exception("Test output!!!");
        return i * 2;
    }
}
```

## Java Lambda Functions

If the interface of a function matches a functional Java interface (Lambda), Lucee automatically implements that interface. 

In the following example, we implement the `IntUnaryOperator` implicitly. You can then pass it to Java and use it as such.

```lucee
int function echoInt(int i) type="java" {
    if (i == 1) throw new Exception("Test");
    return i * 2;
}
dump(echoInt(1));
```
