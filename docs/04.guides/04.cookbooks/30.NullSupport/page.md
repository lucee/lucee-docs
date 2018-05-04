---
title: Null Support
id: null_support
---

## Null Support

This document explains how to set null support in the Lucee server admin, assign null value for a variable and how to use `null` and `nullvalue`. It is an annotation of the video found here:

[Lucee Null Support ](https://www.youtube.com/watch?v=GSlWfLR8Frs)

### Setting NULL support options

We enable null support by using **lucee server admin** --> **Language/compiler** and setting Null support to **complete support** (exclusive to Lucee) or **partial support** (default, same as Adobe CF).

### Explanation

#### Illustration 1:

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

In this example, the function `test()` does not return a value. This, in effect, is the same as returning `null`. If you dump the result of the function (`dump(test());`), you will see that the dump outputs `Empty: Null`.

If we we assign the fuction result to a variable, i.e. `t=test();`, and reference the variable, i.e. `dump(t);` and error will be thrown when using **partial support** for null: "the key [T] does not exist". If we enable **full support**, you will be able to reference the variable without error, the dump output will be `Empty: Null` and `IsNull(t)` will evaluate `true`.

In all cases, `dump(isNull(notexisting));` will throw an error.


#### Illustration 2:

```luceescript
query datasource="test" name="qry" {
	echo("select '' as empty,null as _null");
}
dump(qry);
dump(qry._null);
```

With **partial support** for NULL enabled, `dump(qry._null);` will output an **empty string**. With **full support**, `Empty: null` will be output and `IsNull(qry._null);` will evaluate `true`.


### NullValue() function and null keyword

With **partial support** for NULL, the `NullValue()` function must be used to explicitly return a null value (this will work in all scenarios). For example:

```luceescript
var possibleVariable = functionThatMayOrMayNotReturnNull();
return possibleVariable ?: NullValue();
```

With **full support**, you are able to use the `null` keyword directly and, as illustrated above, can assign it to a variable directly:

```luceescript
t=null;
dump(t);
```
