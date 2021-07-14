### Check to see if an index is defined at a given position

```luceescript+trycf
fruitArray = ['apple', 'kiwi', 'banana', 'orange', 'mango', 'kiwi'];

dump(arrayIsDefined(fruitArray,3)); //true

//member function
dump(fruitArray.isDefined(30)); //false
```