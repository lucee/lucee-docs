### Simple Array

```luceescript+trycf
arr = ['a','b','c','d','e','f','g'];
dump(arrayToStruct(arr));

//member function
dump(arr.toStruct());
```

### Array of Structs

```luceescript+trycf
arr = [
    {name:'a'},
    {name:'b'},
    {name:'c'},
    {name:'d'},
    {name:'e'}
];
dump(arrayToStruct(arr));

//member function
dump(arr.toStruct());
```
