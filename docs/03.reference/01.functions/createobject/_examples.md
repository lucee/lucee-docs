```luceescript+trycf
dump( label:"CreateObject in java",  var:createObject('java','java.util.HashMap'));
dump( label:"CreateObject with init()", var:createObject('java',"java.lang.StringBuffer").init());
```

### All these examples are all functionally identical

*Except that the `new Object()` syntax automatically calls the `init()` method*

```luceescript+trycf
dump( var=createObject("component", "org.lucee.cfml.http"), expand=false );
// but even "component" is optional for cfcs
dump( var=createObject("org.lucee.cfml.http"), expand=false );

// the modern new Object() syntax is also dynamic 
dump(var=new "org.lucee.cfml.http"(), expand=false);
dump(var=new org.lucee.cfml.http(), expand=false);

cfc = "org.lucee.cfml.http";
dump(var=new "#cfc#"(), expand=false);
```