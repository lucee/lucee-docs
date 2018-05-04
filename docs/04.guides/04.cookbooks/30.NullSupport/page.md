---
title: Null Support
id: null_support
---
## Null Support ##

This document explains how to use null support(Complete support or Partial support) in lucee server admin & assign null value for a variable & how to use that keyword `null`,`nullvalue`.

We Enable null support by using **lucee server admin** --> **Language/compiler** --> setting Null support to **complete support** or **partial support**. Explain this method with a simple example below:

###Example 1 :###

```lucee
<cfscript>
	function test() {
	}
	dump(test());

	t=test();
	dump(t);

	dump(isNull(t));
	dump(isNull(notexisting));
</cfscript>
```

* Here Example, If a function that doesn't return a value when the function doesn't give nothing it, actually it returns null.
* I do a dump of that. Then we will see the browser, It returns null value like `Empty : Null`
* Now we assign the fuction for a variable like `t=test();` and dump that variable like `writedump(t);` Execute that example in browser, It throw error like "the key [T] does not exist" while enable **partial support**. 
* As this same example returns null value while enable **complete support**. 
* If in case we dump the same variable T as isNull(T) means it will return true. It means we check not existing variable in isNull() function, it returns true.


###Example 2:###

```lucee
<cfscript>
query datasource="test" name="qry" {
	echo("select '' as empty,null as _null");
}
dump(qry);
dump(qry._null);
</cfscript>
```

* Here example with query and the query returns one field with the value null inside. 
* Then we will run on this browser. It return query as empty string, not a null value while enable **partial support**. Converts null value in the data source table to empty string. 
* As that same example we enable the **complete support** for full more support, it shows like 'Empty:null'


###Example 3:###

```lucee
<cfscript>
sct1={};
sct2={};
// output null returned by a method
dump(sct2.putAll(sct1));
// assign null to a variable
res=sct2.putAll(sct1);
dump(res);
</cfscript>
```

* Here this example have two structure and two methods too, There are

	1. First method returned as null output by using java function
	2. Second one is for assign null to a variable.

* Then we will run on this browser. It return null value for both methods while enable **complete support**. But it return null value for first method only when enable **partial support** in admin side.
* Second one is throw issue `The Key [res] does not exist`. Because the fuction was assigned to a variable like `res=sct2.putAll(sct1)`


###Example 4:###

```lucee
<cfscript>
res=nullValue();
dump(res);

res=null;
dump(res);
dump(null);
</cfscript>
```

* Here we use the keyword `nullvalue()` is used to support null value when we enable **complete support**. 
* We can also use the keyword `null` as same as `nullvalue()`. We will assign this keywords into a variable or directly dump the keyword. 

This null support feature in admin is also helpful when transfer data from json that also support null. 


### Footnotes ###

Here you can see above details in video

[Lucee Null Support ](https://www.youtube.com/watch?v=GSlWfLR8Frs)