### Simple array using sort type and order
```luceescript+trycf
SomeArray = ["COLDFUSION","coldfusion","adobe","LucEE","LUCEE"];


arraySort(SomeArray,"text","desc");
dump(SomeArray);

//member function
SomeArray.sort("text","desc");
dump(SomeArray);
```

### Nested array of structs using closure
```luceescript+trycf
SomeArray = [
    {name="testemployee", age="32"},
    {name="employeetest", age="36"}
];

arraySort(
    SomeArray,
    function (e1, e2){
        return compare(e1.name, e2.name);
    }
);
dump(SomeArray);

//member function
SomeArray.sort(
    function (e1, e2){
        return compare(e1.name, e2.name);
    }
);
dump(SomeArray);
```
