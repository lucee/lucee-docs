```luceescript+trycf
reduced = ArrayReduce( [1,2,3,4], function( carry, value ){ 
    return carry + value;
}, 0 );
dump( reduced ); // yields 10

reduced = ArrayReduce( ['hello', 'there', 'lucee'], function(carry, value){
    return carry & ' ' & value;
}, '' );
dump( reduced ); // yields 'hello there lucee'
```
