<!--
{
  "title": "Hidden Gems",
  "id": "hidden_gems",
  "description": "This document explains how to declare variables, function calls with dot and bracket notation, and passing arguments via URL/form scopes as an array.",
  "keywords": [
    "Hidden gems",
    "Declare variables",
    "Function calls",
    "Dot notation",
    "Bracket notation",
    "URL form scopes",
    "Array format"
  ],
  "categories": [
    "language"
  ]
}
-->

# Hidden Gems

Lesser-known Lucee features that can make your code cleaner and more flexible. These aren't obscure - they're useful patterns that many developers overlook.

## Variable Declaration

```luceescript
// test.cfc
component {
	function getName() {
		return "Susi";
	}
}
```

```luceescript
// example.cfm
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

Declaring `var qry` creates an empty local variable. The query then populates it.

## Bracket Notation for Function Calls

You can call component methods using bracket notation instead of dot notation. This lets you call functions dynamically without the overhead and security concerns of `evaluate()`:

```luceescript
// Standard dot notation
test = new Test();
dump( test.getName() );

// Dynamic with evaluate (avoid this)
funcName = "getName";
dump( evaluate('test.#funcName#()') );

// Dynamic with bracket notation (better!)
funcName = "getName";
dump( test[funcName]() );
```

All three return "Susi", but bracket notation is cleaner and safer than `evaluate()`.

## URL/Form Arrays

When you have multiple form fields or URL parameters with the same name, Lucee normally merges them into a comma-separated string. Adding `[]` to the name tells Lucee to return an array instead - much easier to work with:

```lucee
<cfscript>
	dump(label:"URL", var:url);
	dump(label:"Form", var:form);
	curr = listLast(getCurrentTemplatePath(),'\/');
</cfscript>

<cfoutput>
	<h1>Countries</h1>
	<!--- Note the [] in country[] --->
	<form method="post" action="#curr#?country[]=USA&country[]=UAE">
		<pre>
			Countries Europe:	<input type="text" name="country[]" value="Switzerland,France,Germany" size="30">
			Countries America:	<input type="text" name="country[]" value="Canada,USA,Mexico" size="30">
			<input type="submit" name="send" value="send">
		</pre>
	</form>
</cfoutput>
```

With `country` you get `"USA,UAE"` (string). With `country[]` you get `["USA","UAE"]` (array).

Video: [Lucee Hidden Gems](https://youtu.be/4MUKPiQv1kA)
