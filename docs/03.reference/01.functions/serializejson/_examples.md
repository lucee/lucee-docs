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
    dump( var=deserializeJSON( serializeJSON(q, true) ),
        label='serializeQueryByColumns');
    dump( var=deserializeJSON( serializeJSON(q, 'struct') ), 
        label="'struct'" );
    dump( var=deserializeJSON( serializeJSON(q, 'row') ), 
        label="'row'" );
    dump( var=deserializeJSON( serializeJSON(q, 'column') ),
        label="'column'" );
```
