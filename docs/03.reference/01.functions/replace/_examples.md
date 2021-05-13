```luceescript+trycf

writeDump(replace("xxabcxxabcxx","abc","def"));
writeDump(replace("xxabcxxabcxx","abc","def","All"));
writeDump(replace("abc","a","b","all"));
writeDump(replace("a.b.c.d",".","-","all"));
test = "camelcase CaMeLcAsE CAMELCASE";
test2 = Replace(test, "camelcase", "CamelCase", "all");
writeDump(test2);
replacer = function(find,index,input){
	dump(var=arguments, label="replacement arguments");
	return "-#index#-";
};
writeDump(var=
    replace("one string, two strings, three strings", "string",
    	replacer,
        "all"
    ),
	label="replace with a function"
);

writeDump(var=
    replace("one string, two strings, three strings",
    	{"one": 1, "two": 2, "three": 3, "string": "txt", "text": "string"}),
	label="replace via a struct"
); // struct keys need to be quoted

```
