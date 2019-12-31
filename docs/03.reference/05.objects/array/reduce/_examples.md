```luceescript+trycf
	array = ["lucee","core","dev"];
	reduced = Array.Reduce(function(carry, value){
	    return carry & ' ' & value;
	}, '' );
	writedump( reduced ); // yields 'lucee core dev'
```