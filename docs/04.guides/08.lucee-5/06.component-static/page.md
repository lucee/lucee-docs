---
title: Static support for components
id: lucee-5-component-static
related:
- tag-component
categories:
- component
description: Lucee 5 supports static variables and functions inside components
---

# Static support for components #

**Lucee 5 supports static variables and functions inside components.**

Example:

```luceescript
component {
     // inside the static constructor you can define static variables, this code is executed when the "class" instance is loaded
     static {
            susi=1; // written to the static scope (defining the scope is not necessary)
            static.sorglos=2; // again written to the static scope
     }

     public static function testStatic() {

    }

     public function testInstance() {
          static.testStatic(); // calling a static function
          return static.sorglos; // returning data from the static scope
     }
}
```

The "static" constructor `static {...}` is executed once before the component is loaded for the first time, so every component of the same type shares the same static scope.

You can use static functions and data as follows.

```luceescript
component Test {
   static {
      staticValue=1;
   }
   public static function testStatic(){}
}
```

```luceescript
Test::testStatic();
x=Test:: staticValue;
```
