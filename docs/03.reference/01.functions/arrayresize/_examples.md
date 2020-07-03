### Sets a minimum number of array items for an array

Fills the unset array items with null

```luceescript+trycf
numbers = [ 1, 2, 3, 4 ];

arrayResize(numbers,10);
Dump( numbers ); 

//member function
numbers.resize(15);
Dump( numbers ); 
```
