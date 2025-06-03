Path of components or Java classes to be imported. 

For components:

- Import a specific component: `path="org.lucee.example.MyCFC"`
- Import all components in a package: `path="org.lucee.example.*"`

For Java classes (Lucee 6.2+):

- Standard import: `path="java.util.HashMap"` 
- Type-specific import: `path="java:java.util.HashMap"` (optional)

By default, Lucee uses a single classpath that includes both components and Java classes. 

When there's a naming conflict, Lucee first searches for a component, then for a Java class if the component is not found. 

Specifying the type prefix (`java:` or `cfml:`) is optional but helpful to resolve ambiguities.

In script syntax, the keyword `import` can be used as an alternative:

```cfml
import org.lucee.example.MyCFC;
```

Note: The `java` attribute is an alias for `path` when importing Java classes.