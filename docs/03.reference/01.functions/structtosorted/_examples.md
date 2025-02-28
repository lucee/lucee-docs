### Non-Member Function

```luceescript+trycf
    myNestedStruct = {
        "apple" = { "price" = 3, "quantity" = 10 },
        "banana" = { "price" = 1, "quantity" = 5 },
        "cherry" = { "price" = 2, "quantity" = 8 },
        "date" = { "price" = 4, "quantity" = 12 }
    };
   writeDump(var=myNestedStruct,label="Before sorting");
   writeDUmp(var=StructToSorted(myNestedStruct,"textNoCase","desc",true),label="After sorting");
```

### Example using callback

```luceescript+trycf
    myNumb.4="5";
    myNumb.3="2";
    myNumb.2="3";
    myNumb.1="1";
    cb = function( value1, value2, key1, key2 ){
        if (arguments.value1 < arguments.value2 ) // i.e. desc
            return 1;
        else
            return -1;
    };
    writeDump(var=myNumb, label="Befor sorting");
    writeDUmp(var=StructToSorted( myNumb , cb ), label="After sorting");
```