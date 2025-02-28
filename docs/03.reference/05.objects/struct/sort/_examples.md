### Member Function

```luceescript+trycf
        animals = {
                cat:"rat",
                lion:"deer",
                bear:"fish"
        };
        writedump(var=animals,label="Before sorting");
        sort = animals.sort("text","asc");
        writeDump(var=sort,label="After sorting");
```

### Example using callback (Introduced in 6.2.1.29)

```luceescript+trycf
    myStruct={a="London",b="Paris",c="Berlin",d="New York",e="Dublin"};
    function callback(e1, e2){
        return compare(arguments.e1, arguments.e2);
    }
    writeDump(var=myStruct,label="Before sorting");
    writeDump(var=myStruct.Sort(callback),label="After sorting");
```