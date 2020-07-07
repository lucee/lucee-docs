---
title: Hidden Gems
id: hidden_gems
---
## Hidden Gems ##

This document explains how to declare a variables, function call with dot and bracket notation, Passing arguments via URL/form scopes as array. Explain this three with simple example below:

#### Example 1 : Declare variables ####

// test.cfc

```luceescript
component {
	function getName() {
		return "Susi";
	}
}
```

// example1.cfm

```luceescript
function test() {
	var qry;
	dump(qry);
	query name="qry" datasource="test" {
		echo("select 1 as one");
	}
	dump(qry);
}
test();
```

* In cfm page have test() function with local variable scope, it normally assigned in empty string ``var qry``. Then execute this cfm, the qry is returns "1". 
* Then dump the ``qry`` below of the var declaration. It returns empty string. 

#### Example 2 : Dot and bracket notation for function calls #### 

Lucee allow you to use bracket notations to call a component function. 

//example2.cfm

```luceescript
// UDF call via dot notation
	test=new Test();
	dump( test.getName() );
// Dynamic function name
	funcName="getName";
	dump(evaluate('test.#funcName#()'));
// UDF call via bracket notation
	funcName="getName";
	dump( test[funcName]() );
```

Here this three different types of function call. There are,

* Calling the user defined function ``getname()`` from component.
* Second type of function call is dynamic function name with evaluate function. 
* Third type of function call is user defined function via bracket notation.

These all three different function call returns as same content ``susi`` what you defined in CFC page.

#### Example 3 : Passing arguments via URL/form scopes as Array #### 

Lucee allow to pass URL and Form scope data as an Array instead of a string list.

//example3.cfm

```lucee
<cfscript>
	dump(label:"URL",var:url);
	dump(label:"Form",var:form);
	// current name
	curr=listLast(getCurrentTemplatePath(),'\/');
</cfscript>

<cfoutput>
	<h1>Countries</h1>
	<form method="post" action="#curr#?country[]=USA&country[]=UAE">
		<pre>
			Countries Europe:	<input type="text" name="country[]" value="Switzerland,France,Germany" size="30">
			Countries America:	<input type="text" name="country[]" value="Canada,USA,Mexico" size="30">
			<input type="submit" name="send" value="send">
		</pre>
	</form>
</cfoutput>
```

// index.cfm

```luceescript
directory sort="name" action="list" directory=getDirectoryFromPath(getCurrentTemplatePath()) filter="example*.cfm" name="dir";
loop query=dir {
	echo('<a href="#dir.name#">#dir.name#</a><br>');
}
```

* In this cfm page have available in URL and form scopes. Here names are used as same as two times. 
* Query string on URL scope have same name ``country`` as two times. Similarly form also have two same name ``country``. 
* Execute this cfm page in browser & submit the form. It will showing a single URL string list in merged format instead of two fields & Form fields also merged as single ``country`` field.
* If we add square bracket behind the name ``country[]`` means, it returns as two separated strings in array format. We will see the difference on browser while dumping that name with square bracket. 

These simple ways are helpful for defining a variable as different methods. 

### Footnotes ###

Here you can see above details in video

[Lucee Hidden Gems](https://youtu.be/4MUKPiQv1kAsss)