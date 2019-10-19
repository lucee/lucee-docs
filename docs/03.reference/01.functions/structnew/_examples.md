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

st = [:]; // shorthand syntax for ordered structs, [=] also works
st.c = 1;
st.b = 2;
st.a = 3;
dump(st)
```

**Lucee Tags**
```lucee+trycf
<cfset st = structNew()>
```
