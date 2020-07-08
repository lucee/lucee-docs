
```luceescript+trycf
	original = {
	    "one": {
	        1: "map"
	    },
	    "two": {
	        2: "struct"
	    },
	    "three": {
	        3: "mapstruct"
	    },
	    "four": {
	        4: "structmap"
	    }
	};
	function mapOriginal(k,v) {
	    return v[ListFirst(v.keyList())];
	}
	fixed = original.Map(mapOriginal);
	writeDump([original, fixed]);
```