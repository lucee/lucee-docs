---
title: Annotations
id: annotations
menuTitle: Annotations
categories:
- server
related:
- tag-component
- tag-interface
- tag-function
- tag-property
- language-syntax-differences
- function-getmetadata
---

Annotations in Lucee allow you to add metadata to components, interfaces, functions, and properties using JavaDoc-style documentation blocks (docblocks). 

This metadata is available at runtime via [[function-getmetadata]] but does not affect code execution.

## Docblock Syntax

Annotations are written in docblock comments (`/** ... */`) placed immediately before the element they describe:

```luceescript
/**
 * A user service component
 * @author John Smith
 * @version 1.0
 */
component {

    /**
     * Retrieves a user by ID
     * @id The unique user identifier
     * @return A user struct or null if not found
     * @deprecated Use getUserById() instead
     */
    function getUser( required numeric id ) {
        // implementation
    }

}
```

## Annotation Format

Annotations use the `@name value` format within docblocks:

- **Description**: Text before any `@` tags becomes the description
- **@tags**: Lines starting with `@` followed by a name and optional value

```luceescript
/**
 * This is the description.
 * It can span multiple lines.
 * @param.name The user's name
 * @param.age The user's age
 * @return A greeting string
 * @custom.anything You can use any tag name
 */
function greet( string name, numeric age ) {
    return "Hello #name#!";
}
```

## Supported Elements

Docblock annotations can be applied to:

- [[tag-component]] (`component {}`)
- [[tag-interface]] (`interface {}`)
- [[tag-function]] (both script and tag style)
- [[tag-property]] (`property name="..."`)

## Accessing Annotations

Use [[function-getmetadata]] to retrieve annotations at runtime:

```luceescript
component {
    /**
     * Component description
     * @author Test Author
     */
}

meta = getMetadata( new MyComponent() );
dump( meta.hint );        // "Component description"
dump( meta.author );      // "Test Author"
```

For functions:

```luceescript
/**
 * Function description
 * @return The result
 */
function myFunc() {}

meta = getMetadata( myFunc );
dump( meta.hint );        // "Function description"
dump( meta.return );      // "The result"
```

## Annotations vs Inline Attributes

Lucee distinguishes between:

- **Annotations**: Metadata from docblocks (accessed via [[function-getmetadata]])
- **Inline attributes**: Attributes in the declaration itself (affect behaviour)

```luceescript
/**
 * @mixin controller
 */
function handler() mixin="model" output="false" {
    // The docblock @mixin is annotation metadata
    // The inline mixin="model" is the actual attribute
}
```

**Important**: When there's a conflict, inline attributes take precedence. Docblock annotations that would affect runtime behaviour (`@returntype`, `@output`, etc.) are ignored if they conflict with the actual declaration.

## Annotations Do Not Affect Runtime

Unlike some other CFML engines, Lucee treats docblock annotations as pure metadata. 

They populate [[function-getmetadata]] results but do not change how code executes:

```luceescript
/**
 * @returntype string
 */
public numeric function calculate() {
    return 42;
}
// Return type is numeric (from declaration), not string (from annotation)
```

This design ensures that comments never cause compiler errors or unexpected behaviour changes.

## Common Annotation Tags

While you can use any tag name, these are commonly used:

| Tag | Purpose |
|-----|---------|
| `@param` | Document function parameters |
| `@return` | Document return value |
| `@author` | Author information |
| `@version` | Version number |
| `@deprecated` | Mark as deprecated with reason |
| `@see` | Reference to related documentation |
| `@throws` | Document exceptions that may be thrown |
| `@hint` | Short description (alternative to first line) |

## Parameter Hints

Document function parameters using `@param.paramname` or just the parameter name:

```luceescript
/**
 * Greets a user
 * @name The user's name
 * @age The user's age in years
 */
function greet( string name, numeric age ) {
    return "Hello #name#, you are #age# years old!";
}
```

The parameter hints become available in `getMetadata( greet ).parameters[n].hint`.

## Property Annotations

[[tag-property]] supports docblock annotations:

```luceescript
component accessors="true" {

    /** The user's unique identifier */
    property name="id" type="numeric";

    /**
     * The user's display name
     * @validate required
     */
    property name="displayName" type="string";

}
```

## Best Practices

1. **Use docblocks for documentation** - descriptions, author info, deprecation notices
2. **Use inline attributes for behaviour** - output, returntype, access modifiers
3. **Keep descriptions concise** - first line should be a summary
4. **Document parameters** - helps IDE tooling and API consumers
5. **Mark deprecated code** - use `@deprecated` with migration guidance
