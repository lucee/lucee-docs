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

Lucee runs on the JVM, which means you have access to thousands of Java libraries directly from CFML. Need a high-performance collection? Use Java's `HashMap`. Want to work with ZIP files, parse XML, or use a third-party library? Just instantiate the Java class and call its methods.

If you're new to Java, don't worry - you can start with the basics and learn as you go. Many Java classes map to familiar CFML concepts: `HashMap` is like a struct, `ArrayList` is like an array, `StringBuilder` is for efficient string concatenation.

**Note**: Complete, stable implementation available from Lucee 7.0 (experimental in 6.2).

## Basic Class Instantiation

Create Java objects with `new`, just like CFCs:

```javascript
// HashMap - like a CFML struct, but with Java's Map interface
map = new java.util.HashMap();
map.put( "name", "Lucee" );
dump( map.get( "name" ) ); // "Lucee"

// ArrayList - like a CFML array, but Java-native
list = new java.util.ArrayList();
list.add( "one" );
list.add( "two" );
dump( list.get( 0 ) ); // "one"

// Date - Java's date/time (consider java.time classes for new code)
currentDate = new java.util.Date();
dump( currentDate );
```

### The `java:` Prefix

When a Java class name might conflict with a CFC name, use the `java:` prefix to be explicit:

```javascript
// If you have a CFC called "StringBuilder", this ensures you get the Java class
sb = new java:java.lang.StringBuilder( "Hello" );
sb.append( " World" );
dump( sb.toString() ); // "Hello World"

// BigDecimal for precise decimal math (avoids floating-point issues)
price = new java:java.math.BigDecimal( "19.99" );
tax = new java:java.math.BigDecimal( "0.10" );
total = price.add( price.multiply( tax ) );
dump( total ); // 21.989
```

## Import Statements

Typing `java.util.HashMap` every time gets tedious. Use `import` to bring classes into scope - then use just the class name:

> **Coming from `createObject()`?** If you previously used `createObject( "java", "className", "/path/to/jar" )` to load classes from custom JARs, note that `import` only handles **naming** (short class names vs fully qualified). To control **which JAR or version** is loaded, you need `javaSettings` - see [Import vs javaSettings](#import-vs-javasettings--whats-the-difference) below.

```javascript
// Import specific classes
import java.util.HashMap;
import java.util.ArrayList;

// Now use the short name
map = new HashMap();
list = new ArrayList();

// Import entire packages with wildcard (like CFML's cfimport)
import java.util.*;
import java.text.*;

// Now any class from those packages works without the full path
map = new LinkedHashMap(); // maintains insertion order
format = new SimpleDateFormat( "yyyy-MM-dd" );
dump( format.format( new Date() ) ); // "2024-01-15"
```

## Static Methods and Fields

In Java, some methods belong to the class itself rather than instances - these are "static" methods. You don't need to create an object first; just call them on the class using `::`.

```javascript
// Math utilities - no need to create a Math object
rnd = Math::random(); // 0.0 to 1.0
maxVal = Math::max( 10, 20 ); // 20
rounded = Math::round( 3.7 ); // 4

// System info
timestamp = System::currentTimeMillis();
osName = System::getProperty( "os.name" );

// Parse strings to numbers
number = Integer::parseInt( "42" );
decimal = Double::parseDouble( "3.14" );

// Generate UUIDs
import java.util.UUID;
uuid = UUID::randomUUID();
dump( uuid.toString() );
```

Static fields (constants) work the same way - useful for getting platform-specific values or predefined constants:

```javascript
// Numeric limits
maxInt = Integer::MAX_VALUE; // 2147483647
minInt = Integer::MIN_VALUE; // -2147483648

// Platform-specific file separator ("/" on Unix, "\" on Windows)
separator = java:java.io.File::separator;

// Line separator for the current OS
newline = System::lineSeparator();
```

## Inner Classes and Enums

Java classes can contain other classes inside them (inner classes). To reference these, use `$` between the outer and inner class names. You'll encounter this when working with some Java APIs.

```javascript
// AbstractMap.SimpleEntry is an inner class - use $ to access it
entry = new java:java.util.AbstractMap$SimpleEntry( "name", "Lucee" );
dump( entry.getKey() ); // "name"
dump( entry.getValue() ); // "Lucee"
```

### Enums

Java enums are type-safe constants. Access enum values using `::`:

```javascript
// TimeUnit enum - useful for time conversions
import java.util.concurrent.TimeUnit;
seconds = TimeUnit::SECONDS;
minutes = TimeUnit::MINUTES;

// Convert 2 minutes to seconds
dump( minutes.toSeconds( 2 ) ); // 120

// Thread states (inner enum, so use $)
state = java:Thread$State::RUNNABLE;
allStates = java:Thread$State::values();
dump( allStates );
```

## Class Reflection (Advanced)

Reflection lets you inspect classes at runtime - useful for debugging, building dynamic code, or understanding unfamiliar Java libraries.

> **Note:** The `::class` syntax requires Lucee 7.0+. In 6.2, use `createObject( "java", "java.lang.Class" ).forName( "java.util.HashMap" )` instead.

```javascript
// Get the Class object using ::class
clazz = java.util.HashMap::class;

// Inspect the class
dump( clazz.getName() ); // "java.util.HashMap"
dump( clazz.getSimpleName() ); // "HashMap"
dump( clazz.getSuperclass().getName() ); // "java.util.AbstractMap"

// See what interfaces it implements
for ( iface in clazz.getInterfaces() ) {
    dump( iface.getName() );
}

// List available methods (helpful when learning a new class)
for ( method in clazz.getMethods() ) {
    dump( method.getName() );
}
```

## Import vs javaSettings - What's the Difference?

If you're migrating from the older `createObject()` approach where you specified a JAR path:

```javascript
// Old approach - class name AND JAR path in one call
pdfLoader = createObject( "java", "org.apache.pdfbox.Loader", "/lib/pdfbox-3.0.6.jar" );
```

You might expect `import` to replace this entirely. But these are two separate concerns:

- **`import`** = Naming convenience ("use `Loader` instead of `org.apache.pdfbox.Loader`")
- **`javaSettings`** = Classpath control ("load this specific library version")

If you use `import` without `javaSettings`, Lucee loads from whatever's already available - often its bundled libraries. This can cause confusion when you expect a specific version.

### Using a Specific Library Version

To use a particular version of a library (like PDFBox 3.x instead of Lucee's bundled 2.x), combine `javaSettings` with `import`:

```javascript
component javaSettings='{"maven":["org.apache.pdfbox:pdfbox:3.0.6"]}' {
    import org.apache.pdfbox.Loader;
    import java.io.File;

    function loadPDF( path ) {
        return Loader::loadPDF( new File( arguments.path ) );
    }
}
```

The `javaSettings` attribute tells Lucee to fetch PDFBox 3.0.6 from Maven. The `import` statements then let you use short class names within that component.

### Where to Define javaSettings

You can define `javaSettings` at different scopes:

| Scope | Use Case |
|-------|----------|
| **Component attribute** | Isolate dependencies to a single component |
| **Application.cfc** | Share dependencies across your application |
| **`.CFConfig.json`** | Server-wide defaults |

For full details on Maven integration, local JARs, and dependency management, see [Maven Integration](maven.md).
