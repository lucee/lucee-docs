### Sample syntax

```lucee
 <cfproperty name="UnitId" column="unit_id" unique="true" fieldtype="id" type="string" />
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
