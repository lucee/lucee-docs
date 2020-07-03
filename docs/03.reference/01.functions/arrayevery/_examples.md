### Loops over every element in the array

```luceescript+trycf
my_array = [ { name = "Frank", age = 40 }, { name = "Sue", age = 21 }, { name = "Jose", age = 54 } ];
all_old = my_array.every(function(person) {
    return person.age >= 40;
},true,5);

dump(all_old); // false
```
