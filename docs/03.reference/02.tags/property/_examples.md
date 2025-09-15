### Sample syntax

```lucee
 <cfproperty name="UnitId" column="unit_id" unique="true" fieldtype="id" type="string" />
```

### Serializing a CFC's properties to JSON

```luceescript+trycf
myCfc = new component accessors="true"{
  property name="foo" type="string";
  property name="bar" type="numeric";
  // NOTE: nulls are skipped when serializing
  property name="unset" type="numeric";
  foo = "hello";
  bar = 42;
};
dump(myCfc); // See CFC object with properties
jsonString = serializeJson(var=myCfc, compact=false);
writeOutput(jsonString); // Output: {"foo":"hello","bar":42}
```

### Improve type handling and defaults with Lucee 7

```luceescript+trycf
myCfc = new component accessors="true" {
  property name="foo" type="string";
  property name="bar" type="numeric";
  property name="arr" type="array" default="#[1,2,3]#";
  property name="st" type="struct" default="#{lucee:"rocks"}#";
  foo = "hello";
  bar = 42;
};
dump(myCfc); // See CFC object with properties
jsonString = serializeJson(var=myCfc, compact=false);
writeOutput(jsonString); // Output: {"foo":"hello","bar":42}
```
