```
ArrayReduce([1,2,3,4], function(carry, value){ return carry + value }, 0)
// Yields: 10

ArrayReduce(['hello', 'there', 'lucee'], function(carry, value){ return carry & ' ' & value }, '')
// Yields: hello there lucee
```
