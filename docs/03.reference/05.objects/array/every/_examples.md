```luceescript+trycf
	array = [ { name = "Frank", age = 40 }, { name = "Sue", age = 21 }, { name = "Jose", age = 54 } ];
	all_old = array.every(function(person) {
	    return person.age >= 40;
	},true,5);
	dump(all_old); // false
```
