### Tag based syntax

```lucee
<cfcomponent displayname="Hello" output="false" style="document" hint="hint for Hello">
    <!--- functions and other values here -->
</cfcomponent>
```

### Script based syntax

```luceescript
component displayname="Script Widget" output="false" {
 // functions and properties here
}
```

### Serializing a CFC's properties to JSON

```luceescript+trycf
myCfc = new component {
  property name="foo" type="string";
  property name="bar" type="numeric";
  foo = "hello";
  bar = 42;
};
dump(myCfc); // See CFC object with properties
jsonString = serializeJson(var=myCfc, compact=false);
writeOutput(jsonString); // Output: {"foo":"hello","bar":42}
```
