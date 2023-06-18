```luceescript+trycf
  qry = query(
    id: [ 1, 2, 3, 4 ],
    name: [ "mssql", "mysql", "image", "pdf" ],
    version: [ "7.2.2.jre8", "8.0.30", "1.0.0.42", "1.1.0.7" ]
  );

  basic = queryToStruct( qry, "name");
  dump( var=basic, label="basic (ordered)");
  
  normal = queryToStruct( qry, "version", "normal", false);
  dump( var=normal, label="normal (unordered)");
  
  row = queryToStruct( qry, "version", "normal", true);
  dump( var=row, label="valueRowNumber=true,unordered");
  
  member = qry.ToStruct("id");
  dump(var=member, label="member");
```