```luceescript+trycf
  st = structNew();
  st.id = 1;
  st.Name = "Water";
  st.DESIGNATION = "Important source for all";
  st.data = [1,2,3,4,5];

  json= serializeJSON(st);
  writeDump(json);
  writeDump(deserializeJSON(json));
```

### Query Formats

```luceescript+trycf
    q = queryNew(
        "id,name",
        "numeric,varchar",
        {
            id: [1,2,3],
            name: ['Neo','Trinity','Morpheus']
        }
    );
    dump(q);
    dump( var=deserializeJSON( serializeJSON(q) ),
        label="default" );
     dump( var=deserializeJSON( serializeJSON(q, true), false ),
        label="true" );     
    dump( var=deserializeJSON( serializeJSON(q, true) ),
        label='serializeQueryByColumns');
    dump( var=deserializeJSON( serializeJSON(q, 'struct') ),
        label="'struct'" );
    dump( var=deserializeJSON( serializeJSON(q, 'row') ),
        label="'row'" );
    dump( var=deserializeJSON( serializeJSON(q, 'column') ),
        label="'column'" );
```

### Pretty Printing

```lucee+trycf
<cfscript>
    obj = {
        name: "lucee",
        versions: [ 5,6,7 ]
    }
</cfscript>
<cfoutput>
<pre>
<b>Default behavior</b>
#serializeJson(var=obj,compact=true)#

<b>Pretty Print (compact=false)</b>
#serializeJson(var=obj,compact=false)#
</pre>
</cfoutput>

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

### Date format (Lucee 9.0 and later)

Define the format for dates in the `Application.cfc`:

```lucee
component {

	this.name = "myApp";
	this.timezone = "Europe/Zurich";

	// "cf" (default), "iso", "isoms" or a custom mask like "yyyy-MM-dd HH:mm:ss"
	this.serialization.dateFormat = "iso";

}
```

```luceescript
echo( serializeJSON( { "created": createDateTime( 2021, 1, 29, 11, 45, 26 ) } ) );
// {"created":"2021-01-29T11:45:26+01:00"}
```

Or for all applications in the `.CFConfig.json`:

```json
{
	"serialization": {
		"dateFormat": "iso"
	}
}
```
