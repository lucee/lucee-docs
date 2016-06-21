### Modify an array and store it back into the array 
Does not modify existing array, creates a new array and stores it to the assigned variable

```luceescript+trycf
aNames = ["Marcus","Sarah","Josefine"];
dump(aNames);

newNames1 = arrayMap(aNames,function(item,index,arr){
    return {'name':item};
});
dump(newNames1);

//member function
newNames2 = aNames.map(function(item,index,arr){
    return {'name':item};
});
dump(newNames2);
```
