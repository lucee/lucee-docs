```luceescript+trycf
json = '{
	"stringValue":"a string", 
	"arrayValue": ["a","b","c"], 
	"booleanValue":true, 
	"numericValue": 42
}';
myStruct = deserializeJson(json);

writeDump(myStruct);
```
*Credit to Adam Cameron for [suggesting the example](http://blog.adamcameron.me/2016/01/coldfusion-how-not-to-document-function.html)*
 
### Strict Mapping with Queries

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
    dump( var=deserializeJSON( serializeJSON(q, 'column'),true ),
        label="'strictMapping TRUE'" );
    dump( var=deserializeJSON( serializeJSON(q, 'column'),false ),
        label="'strictMapping FALSE'" );

    q= { nested1: q, nested2: {q3: q} };
    dump( var=deserializeJSON( serializeJSON(q),false ),
        label="'strictMapping FALSE *nested queries*'" );
```