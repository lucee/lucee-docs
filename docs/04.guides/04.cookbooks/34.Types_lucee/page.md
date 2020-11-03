---
title: Types in lucee
id: types_lucee
---
## Types in lucee ##

This document explains types in Lucee. Lucee is still an untyped language. Types are only a check put on top of the language. The language is not based on types, however there are different places where types come into Lucee. This is explained with some simple examples below:

#### Example 1 : Function Argument and Return Value ####

For functions, the return value is returned with the specific type that was defined in that function.

```luceescript

// function1.cfm

	param application.names={};
	boolean function recExists(string name, number age) {
		var exists = application.names.keyExists(name);
		application.names[name]=age;
		dump(age);
		return exists;
	}
	dump(recExists("Susi","15"));
	void function test(array arr) {
		arr[2]="two";
	}
	arr={'1':'one'};
	test(arr);
	dump(arr);
```

* This example function has two arguments: name, age (One is a string, the other is a number). When this example is executed, the recExists() function checks if a certain record exists or not and It returns the boolean value ``true``.
* When dumping the function recExists() with arguments, if we give age as a string format in the argument, ``dump(recExists("Susi","15"))``, it shows ``string 15`` even though we defined it as a number data type in the arguments.
* The test() function takes an array, but in this example I do not pass an array into the function. I have passed a struct ``arr={'1':'one'}`` value into the test() function. The test() function contains an array value ``arr[2]= "two"``, so Lucee converts this array value into a structure. So the struct has two values as per keys are 1, 2 and values are one, two.
* Lucee can handle an array as long as the keys are all numbers, meaning it considers a struct ``'1' and [2]``. Execute this cfm page, the dump shows the structure format.

#### Example 2 : CFParam ####

```luceescript

// param.cfm

param name="url.age" type="number";
dump(label:"Age:", var:url.age);
```

* In this example the dump of the age parameter has a URL scope. If you execute this cfm page without passing any value into the URL for age, it will throw an error like ``The required parameter [url.age] was not provided``.
* If I pass a numeric value ``age=15``for age in the URL, it returns as expected, 15.
* If I pass a string value ``age=old`` for age in the URL, it throws an error like ``Can't cast string [old] to a value of type [value]``

#### Example 3 : Queries ####

```luceescript

//queries.cfm

query=queryNew(["name","age"],["string","numeric"]);
	row=query.addRow();
	query.name[row]="Susi";
	query.age[row]=16;

	row=query.addRow();
	query.name[row]="Heidi";
	query.age[row]=9;

	query.sort("age");
	dump(query);
	dump(getMetaData(query));

	row=query.addRow();
	query.name[row]="Urs";
	query.age[row]="old";

	query.sort("age");
	dump(query);
	dump(getMetaData(query));
```

* This example has queryNew() with two columns. Name and age are defined in string and numeric format. Then the example adds two rows of values to the columns. Then we dump the query with getMetaData(). It returns the column name with the corresponding data type of the field.
* If I change the age to as string format, ``query.age[row]="old"``, it does not throw an exception. It considers both name and age fields to be varchar type.

#### Example 4 : ArrayNew ####

```luceescript

// array.cfm

names=arrayNew(type:"string");
	names[1]="Susi";
	names[2]="Heidi";
	names[3]=7.9;
		dump(names);
	names[4]={a:1};
// arrayNew["string"](1);
```

* This example demonstrates the new functionality of ACF_2018, Lucee5.3. Here we define arrayNew with type:"string".
* If we give a string or number value for the array, it returns a string format. Otherwise, if we give a struct value, ``{a:1}``, into the array, it throws an error like ``Can't cast complex object type struct to string``.

#### Example 5 : Literals ####

```luceescript

// literals.cfm

sct.bol=true;
sct.str="String";
sct.nbr=123.456;
	dump(sct);
	dump(sct.nbr+100);
if(sct.bol)dump("is true");
	dump(serializeJson(sct));
```

* Here we define three literals: literal boolean, literal string, literal number.
* Execute this example. The dump ``sct`` returns with their data type with values.
* We dump the number with a mathematical operation ``sct.nbr+100`` on it, and it returns ``223.456``. It checks the boolean literal as boolean or not. It returns "is true" while the if condition satisfied.

#### Example 6 : Converting ####

```luceescript

//converting.cfm

// convert string to date
	d=dateAdd("d",0,"12/1/2018");
	dump(d);
// convert date to number
	n=d+1;
	dump(n);
// convert number to date
	d=dateAdd("d",0,n);
	dump(d);
	sb=createObject("java","java.lang.StringBuilder").init("Susi Sorglos");
	dump(sb);
	dump(sb.substring("5"));
	dump(sb.substring(JavaCast("int","5")));
//sb=createObject("java","java.lang.StringBuilder").init("1");
	sb=createObject("java","java.lang.StringBuilder").init(javaCast("int","1"));
	dump(sb);
```

* Internally every object has a type and Lucee automatically takes care of converting from one type to another if necessary. For example when you define a function with a string, but then pass a number into that function, Lucee automatically converts the number to a string.
* The above example is useful for converting "string to date", "date to number", "number to date" formats.
* We have loaded a Java library and string builder. We pass a string into a constructor and execute this. We see that the string builder contains that value. We refer to this ``string builder`` method in the Java Doc. The method is called ``substring``. This substring takes an int as its argument. For example, we pass a string value instead of an int value ``sb.substring("5")``. Lucee returns a substring properly.
* Two constructors are available for string builder. There are ``StringBuilder(int), StringBuilder(string)``.

```luceescript

//index.cfm

directory sort="name" action="list" directory=getDirectoryFromPath(getCurrentTemplatePath()) filter="example*.cfm" name="dir";
loop query=dir {
	echo('<a href="#dir.name#">#dir.name#</a><br>');
}
```

```luceescript

// test.cfc

component {
	function getName() {
		return "Susi";
	}
}
```

These types are on top of the language. Lucee contains some other different types too. Therefore, it is always good to do type checking in your code.

### Footnotes ###

Here you can see above details in video

[Types of Lucee](https://youtu.be/02kMrN4PByc)
