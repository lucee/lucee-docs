**Lucee Script**

```luceescript+trycf
dump(var=structNew("soft"), label="soft");
dump(var=structNew("weak"), label="weak");
dump(var=structNew("linked"), label="linked");

st = {
    "one": [1,2,3],
    "two": {
        "three": QueryNew("id")
    },
    three: "unquoted keys don't preserve case"
};

dump( st );
dump( structKeyList(st) );
dump( structKeyExists(st, "one") );

// shorthand syntax for a new empty ordered struct, [=] also works
st = [:];
st.c = 1;
st.b = 2;
st.a = 3;
dump(st);

// shorthand syntax for an ordered struct with values
st = [
    c: 1,
    b: 2,
    a: 3
];
dump(st);
```

**Lucee Tags**
```lucee+trycf
<cfset st = structNew()>
```