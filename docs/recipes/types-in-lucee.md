<!--
{
  "title": "Data Types in Lucee",
  "id": "types-in-lucee",
  "description": "This document explains types in Lucee. Lucee is still an untyped language. Types are only a check put on top of the language.",
  "keywords": [
    "Types",
    "Function argument",
    "Return value",
    "CFParam",
    "Lucee"
  ],
  "categories": [
	"core",
	"decision"
  ],
  "related":[
	"developing-with-lucee-server",
	"tag-param",
	"function-isInstanceOf"
  ]
}
-->

# Types in Lucee

Lucee is an untyped language - types are validation checks layered on top. Lucee automatically converts between types when needed.

### Function Argument and Return Value

When you define argument types on a function, Lucee checks if the passed value is **castable** to that type - it doesn't actually cast it. The value retains its original type inside the function.

```luceescript
function greet( string name ) {
	dump( name ); // still a number internally, even though type is "string"
}
greet( 123 ); // passes - 123 is castable to string
```

For return values, Lucee validates the returned value matches the declared type.

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

- This example function has two arguments: name, age (One is a string, the other is a number). When this example is executed, the recExists() function checks if a certain record exists or not and It returns the boolean value `true`.
- When dumping the function recExists() with arguments, if we give age as a string format in the argument, `dump(recExists("Susi","15"))`, it shows `string 15` even though we defined it as a number data type in the arguments.
- The test() function takes an array, but in this example I do not pass an array into the function. I have passed a struct `arr={'1':'one'}` value into the test() function. The test() function contains an array value `arr[2]= "two"`, so Lucee converts this array value into a structure. So the struct has two values as per keys are 1, 2 and values are one, two.
- Lucee can handle an array as long as the keys are all numbers, meaning it considers a struct `'1' and [2]`. Execute this cfm page, the dump shows the structure format.

### CFParam and Type Conversion

```luceescript

// param.cfm

param name="url.age" type="numeric" default=10;
param name="url.name" type="string" default="Susi";
param name="url.mails" type="array" default=["Susi@lucee.org"];
dump(url);

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

- Internally every object has a type and Lucee automatically takes care of converting from one type to another if necessary. For example when you define a function with a string, but then pass a number into that function, Lucee automatically converts the number to a string.
- The above example is useful for converting "string to date", "date to number", "number to date" formats.
- We have loaded a Java library and string builder. We pass a string into a constructor and execute this. We see that the string builder contains that value. We refer to this `string builder` method in the Java Doc. The method is called `substring`. This substring takes an int as its argument. For example, we pass a string value instead of an int value `sb.substring("5")`. Lucee returns a substring properly.
- Two constructors are available for string builder. There are `StringBuilder(int), StringBuilder(string)`.

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

## Disabling Type Checking

Type checking adds overhead. For performance-critical production environments, you can disable UDF type checking entirely.

### System Property

```sh
-Dlucee.udf.type.checking=false
```

### Environment Variable

```sh
LUCEE_UDF_TYPE_CHECKING=false
```

This is an alias for the older `lucee.type.checking` / `LUCEE_TYPE_CHECKING` settings.

### Application.cfc

```luceescript
this.typeChecking = false;
```

When disabled, Lucee skips argument and return type validation - values pass through without checks.

## Footnotes

Here you can see above details in video

[Types of Lucee](https://youtu.be/02kMrN4PByc)
