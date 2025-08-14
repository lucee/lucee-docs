<!--
{
  "title": "Java Class Interaction",
  "id": "java-class-interaction",
  "since": "7.0",
  "categories": ["java", "interop", "objects"],
  "description": "Documentation for interacting with Java classes and objects in Lucee",
  "keywords": [
    "Java",
    "Classes",
    "Objects",
    "Interop",
    "Static Methods",
    "Inner Classes",
    "Reflection"
  ],
  "related": [
    "function-createobject"
  ]

}
-->

# Java Class Interaction

Lucee provides seamless integration with Java classes, allowing you to instantiate objects, call methods, and access static members directly from CFML code. This powerful feature enables you to leverage the entire Java ecosystem within your Lucee applications.

## Overview

Java class interaction in Lucee supports multiple approaches for working with Java objects:

- Implicit class loading using standard Java syntax
- Explicit class loading with the `java:` prefix
- Import statements for cleaner code
- Static method calls and field access
- Inner and nested class instantiation
- Class reflection capabilities

**Note**: This feature was partially available as an experimental feature in Lucee 6.2, but should not be used in production systems with that version. The complete, stable implementation is available starting with Lucee 7.0.

## Basic Class Instantiation

### Implicit Loading

The most straightforward way to create Java objects is using implicit loading with the `new` keyword:

```javascript
// Create a HashMap instance
map = new java.util.HashMap();
dump(map);

// Create an ArrayList with initial capacity
list = new java.util.ArrayList(10);
dump(list);

// Create a Date object
currentDate = new java.util.Date();
dump(currentDate);
```

### Explicit Loading

For better clarity and to avoid potential conflicts, you can use explicit loading with the `java:` prefix:

```javascript
// Create a HashMap explicitly
map = new java:java.util.HashMap();
dump(map);

// Create a StringBuilder with initial value
sb = new java:java.lang.StringBuilder("Hello World");
dump(sb);

// Create a BigDecimal for precise calculations
decimal = new java:java.math.BigDecimal("123.456");
dump(decimal);
```

## Import Statements

Use import statements to simplify class names and make your code more readable:

```javascript
// Import specific classes
import java.util.HashMap;
import java.util.ArrayList;
import java.lang.StringBuilder;

// Now you can use simplified names
map = new HashMap();
list = new ArrayList();
sb = new StringBuilder("Test");

dump(map);
dump(list);
dump(sb);

// Import entire packages with wildcard
import java.util.*;
import java.text.*;

// Use any class from imported packages
map = new HashMap();
list = new LinkedList();
format = new SimpleDateFormat("yyyy-MM-dd");

dump(map);
dump(list);
dump(format);
```

## Static Method Calls

Access static methods using the double colon (`::`) operator:

### Implicit Static Calls

```javascript
// Call Math.random()
rnd = Math::random();
dump(rnd);

// Call System.currentTimeMillis()
timestamp = System::currentTimeMillis();
dump(timestamp);

// Call Integer.parseInt()
number = Integer::parseInt("42");
dump(number);

// Call Arrays.toString()
import java.util.Arrays;
arr = [1, 2, 3, 4, 5];
str = Arrays::toString(arr);
dump(str);
```

### Explicit Static Calls

```javascript
// Call static methods explicitly
rnd = java:Math::random();
dump(rnd);

// Call System properties
osName = java:System::getProperty("os.name");
dump(osName);

// Call UUID generation
import java.util.UUID;
uuid = java:UUID::randomUUID();
dump(uuid);
```

## Static Field Access

Access static fields (constants) using the same syntax:

```javascript
// Access Integer constants
maxInt = java:Integer::MAX_VALUE;
minInt = java:Integer::MIN_VALUE;
dump(maxInt);
dump(minInt);

// Access Calendar constants
import java.util.Calendar;
monday = Calendar::MONDAY;
sunday = Calendar::SUNDAY;
dump(monday);
dump(sunday);

// Access File separator
separator = java:java.io.File::separator;
dump(separator);
```

## Inner and Nested Classes

Lucee supports instantiation of inner and nested classes using the `$` delimiter:

### Static Nested Classes

```javascript
// Create a Map.Entry using AbstractMap.SimpleEntry
entry = new java:java.util.AbstractMap$SimpleEntry("count", 42);
dump(entry);

// Access the key and value
dump("Key: " & entry.getKey());
dump("Value: " & entry.getValue());

// Create a Rectangle2D.Double
rectangle = new java:java.awt.geom.Rectangle2D$Double(10.0, 20.0, 100.0, 50.0);
dump(rectangle);
dump("Area: " & (rectangle.getWidth() * rectangle.getHeight()));
```

### Enum Classes

```javascript
// Access Thread.State enum values
state = java:Thread$State::RUNNABLE;
dump(state & ""); // Convert to string for display

// Get all enum values
states = java:Thread$State::values();
dump(states);

// Access other enum types
import java.util.concurrent.TimeUnit;
seconds = TimeUnit::SECONDS;
minutes = TimeUnit::MINUTES;
dump(seconds);
dump(minutes);
```

### Character Inner Classes

```javascript
// Access Character.UnicodeBlock
basicLatin = java:Character$UnicodeBlock::BASIC_LATIN;
dump(basicLatin);

// Check if a character belongs to a Unicode block
testChar = asc("A");
block = java:Character$UnicodeBlock::of(testChar);
dump("Character 'A' belongs to: " & block);

// Access Character.UnicodeScript
latin = java:Character$UnicodeScript::LATIN;
dump(latin);
```

## Class Reflection

Get Java Class objects for reflection purposes:

### Implicit Class Access

```javascript
// Get the Class object for HashMap
clazz = java.util.HashMap::class;
dump(clazz);

// Get class name and methods
dump("Class name: " & clazz.getName());
dump("Simple name: " & clazz.getSimpleName());

// Get constructors
constructors = clazz.getConstructors();
dump("Number of constructors: " & arrayLen(constructors));
```

### Explicit Class Access

```javascript
// Get Class object explicitly
clazz = java:java.util.HashMap::class;
dump(clazz);

// Get superclass
superClass = clazz.getSuperclass();
dump("Superclass: " & superClass.getName());

// Get interfaces
interfaces = clazz.getInterfaces();
dump("Implements " & arrayLen(interfaces) & " interfaces");

// Check if it's an interface, enum, etc.
dump("Is interface: " & clazz.isInterface());
dump("Is enum: " & clazz.isEnum());
```