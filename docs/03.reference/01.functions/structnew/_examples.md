**Lucee Script**

```luceescript+trycf
st = structNew("soft");
st = structNew("weak");
st = structNew("linked");

st = {
    "one": [1,2,3],
    "two": {
        "three": QueryNew("id")
    }
};
dump( st );
dump( structKeyList(st) );
dump( structKeyExists(st, "one") );
```

**Lucee Tags**
```lucee+trycf
<cfset st = structNew()>
```