---
title: Static scope in components
id: static_scope
---
## Static scope in components ##

Static scope in components is needed to create an instance of cfc and call its method. It is used to avoid creating an instance each time you use the cfc. You can create an object in the Application init() function, and make it at application scope, so you can directly call the methods. We explain this methodology with a simple example below:


###Example:###

```luceescript
// index.cfm
directory sort="name" action="list" directory=getDirectoryFromPath(getCurrentTemplatePath()) filter="example*.cfm" name="dir";
loop query=dir {
	echo('<a href="#dir.name#">#dir.name#</a><br>');
}
```

1) Create a constructor of the component. It is the instance of the current path and also create new function hey(). 

```luceescript
// Example0.cfc
	Component {
		public function init() {
			dump("create an instance of "&listLast(getCurrentTemplatePath(),'\/'));
		}
		public function hey() {
			dump("Salve!");
		}
	}
```

2) Next, we instantiate the component four times, and then call the hey() function. Run this example00.cfm page in the browser. It shows five dumps. Four dumps coming from inside of the constructor and the fifth dump is from hey(). Note that the init() function is private, so you cannot load it from outside the component. Therefore, you have no access to the message within init() from the cfscript in the example below.

```luceescript
// example0.cfm
	new Example0();
	new Example0();
	new Example0();
	cfc=new Example0();
	cfc.hey();
```


###Example 1:###

As our code gets more complicated, we need to make some additions to it.

* One option is to create the Component in the application scope or server scope, or to use the function GetComponentMetaData to store components in a more persistent way.
* However, using the static scope is a much better option which offers more control in how you load and how you share the data between components of the specific type. This is explained in Example1 below.

1) This code has a new static function getInstance(). This function is not a part of the instance in Component. It is static of the specific component, but not created in any instance.

```luceescript
// Example1.cfc
Component {
	public static function getInstance() {
		if(isNull(static.instance)) {
			static.instance=new Example1();
		}
		return static.instance; 
	}
	private function init() {
		dump("create an instance of "&listLast(getCurrentTemplatePath(),'\/'));
	}
	public function hey() {
		dump("Salve!");
	}
}
```

2) This example calls the getInstance() static function four times, and calls the hey() function once.

* Next, we run this in the browser to see that the constructor calls only one instance, and function hey() is called once. It always gets the same instance because only one exists at this time.
* We give an additional request to the same page again. No constructor is displayed. Only the hey() function contents are shown. Therefore, we know that the constructor is only showing the first request of the page.

```luceescript
// example01.cfm
	Example1::getInstance();
	Example1::getInstance();
	Example1::getInstance();
	cfc=Example1::getInstance();
	cfc.hey();
```

###Example 2:###

1) Example2 shows the same concepts that were shown in the previous Example1, but here we pass two instances for arguments. One instance for every combination of arguments passed in firstname, lastname. Then we also call the hey() function.

```luceescript
// Example2.cfc 
Component {
	public static function getInstance(required string lastname, required string firstname) {
		var id=hash(lastname&":"&firstname,"quick");
		if(isNull(static.instance[id])) {
			static.instance[id]=new Example2(lastname,firstname);
		}
		return static.instance[id];
	}
	private function init(required string lastname, required string firstname) {
		dump("create an instance of "&listLast(getCurrentTemplatePath(),'\/')&" for "&lastname&" "&firstname);
		variables.lastname=arguments.lastname;
		variables.firstname=arguments.firstname;
	}
	public function hey() {
		dump("Salve #variables.firstname#!");
	}
}
```

2) Next we call the getInstance() static function five times. Here we pass three different arguments into the getInstance() function. So three instances are displayed when we run this in the browser. This indicates that the same arguments are executed only once.  

```luceescript
// example02.cfm
	Example2::getInstance("Quintana","Jesus");
	Example2::getInstance("Sobchak","Walter");
	Example2::getInstance("Sobchak","Walter");
	Example2::getInstance("Sobchak","Walter");
	Example2::getInstance("Sobchak","Walter").hey();
```

###Example 3:###

1)This example is to show the difference between the body of the instance constructor and the static constructor.

* The static constructor constructs the whole execution when the component is loaded in the memory for first time only. It does not create the same (duplicate) instance again for the execution.
* A new instance is created for every execution of an instance constructor.

```luceescript
// Example3.cfc
Component {
	//instance constructor body
	dump("this is executed every time a new instance is created");

	//static constructor body
	static {
		dump("this is executed only if the component is loaded for the first time");
	}
}
```

2) Here we call the Example3() function twice. The first request will display three instances when run in the browser. The static constructor body will execute one time, and the instance constructor body will execute two times.

```luceescript
// example03.cfm
	new Example3();
	new Example3();
```

###Example 4:###

1) This example shows the count of how many instances of the component get loaded. In this example we define the body of the static constructor as zero, then increase the count. The instance of the component can always access the static scope because that allows you to share data between multiple instances of the component.

```luceescript
// Example4.cfc
Component {
	static {
		static.counter = 0 ;
	}
	static.counter++;

	dump(static.counter&" instances used so far");
}
```

2) Here we call the Example4() function five times. Each time the function is called, the count of counter in the static scope increases.

```luceescript
// example04.cfm 
	new Example4();
	new Example4();
	new Example4();
	new Example4();
	new Example4();
```

###Example 5:###

1) We can also use the static scope to store constant data like HOST,PORT.

* If we store the instance in the variable scope, you will run into problems when you have a thousand components or it gets loaded a thousand times. This is a waste of time and memory storage.
* The Static scope means that a variable example only exist once and is independent of how many instances you have. So it is more memory efficient to do it that way. You can also do the same for functions.


```luceescript
// Example5.cfc
Component {
	static{
		static.HOST="lucee.org";
		static.PORT=8080;
	}
	public static function splitFullName(required string fullName) {
		var arr=listToArray(fullName," 	");
		return {'lastname':arr[1],'firstname':arr[2]};
	}
	public function init(required string fullname) {
		variables.fullname=static.splitFullName(fullName);
	}
	public string function getLastName() {
		return variables.fullname.lastname;
	}
}
```

2) Here we call the Example5() function in two ways. It has a function splitFullName() that does not need to access anything (read or write data from the disks) and a variable scope that doesn't have to be part of the instance. It returns the firstname and lastname.

```luceescript
// example05.cfm
	person=new Example5("Sobchak Walter");
	dump(person.getLastName());
	dump(Example5::splitFullName("Quintana Jesus"));
```

### Footnotes ###

Here you can see above details in video

[Lucee Static Scopes in Component Code ](https://www.youtube.com/watch?v=B5ILIAbXBzo&feature=youtu.be)
