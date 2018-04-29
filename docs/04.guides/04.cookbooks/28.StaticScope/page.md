---
title: Static scope in components
id: static_scope
---
## Static scope in components ##

Static scope in components is need to create an instance of cfc and call it's method. It used to avoid creating instance each time, you can create object in Application init() function, and make it at application scope, so you can directly call the methods. We explain this method with a simple example below:


###Example:###

1) Create a constructor of the component. It is the instance of the current path and also create new function hey(). 

```lucee
// Example0.cfc
	Component {
		private function init(){
			dump("create an instance of" & listlast(getCurrentTemplatePath(),'\/'));
		}
		public function hey(){
			dump("salve !");
		}
	}
```

2) Then We instantiate the component in four times and calling the hey() function. Run this example00.cfm page in the browser. It shows five dumps. Four dumps coming from inside of the constructor & Fifth dump is from hey().  Here init() is privately, so don't can load it anymore from outside because it's private you have to no access to its message can't load it from outside. 

```lucee
// example00.cfm
<cfscript>
	new Example0();
	new Example0();
	new Example0();
	cfc = new Example0();
	cfc.hey();
</cfscript>
```


###Example 1:###

We need more control while it get complicated, I've to do some stuff around. There are, 

* Component in the application scope or server scope or use the function get component metadata to store components in a more persistent way, it almost good. 
* But the static scope helps much more control in how you load and how you share the data between component of the specific type. So explain this on example1 below,

1) It has a new static function getInstance(), That function is not a part of the instance in component. It is static of the specific component, but not created any instance.

```lucee
// Example1.cfc
Component {
	public static function getInstance() {
		if(isNull(static.instance)){
			static.instance = new Example1();
		}
		return static.instance; 
	}
	private function init(){
		dump("create an instance of" & listlast(getCurrentTemplatePath(),'\/'));
	}
	public function hey(){
		dump("salve !");
	}
}
```

2) Calling that getInstance() static function in four times and call hey() function too. 

* Then we run this on browser to see the constructor is call only one instance and function hey() call once. It always get same instance are only exist at one time. 
* We give additional request the same page again means no constructor is displayed, only shows hey() function contents. Here we know constructor only show first request of the page. 

```lucee
// example01.cfm
<cfscript>
	Example1::getInstance();
	Example1::getInstance();
	Example1::getInstance();
	cfc = Example1::getInstance();
	cfc.hey();
</cfscript>
```

###Example 2:###

1) As same concepts of previous Example, but Here we pass two instance for arguments. One instance for every combination of argument passed in firstname, lastname. And also call hey() function.

```lucee
// Example2.cfc 
Component {
	public static function getInstance(required string lastname, required string firstname) {
		var id = hash(lastname&":"&firstname,"quick");
		if(isNull(static.instance[id])){
			static.instance[id] = new Example2(lastname,firstname);
		}
		return static.instance(id); 
	}
	private function init(required string lastname, required string firstname) {
		dump("create an instance of" & listlast(getCurrentTemplatePath(),'\/')&" for "&lastname&" "&firstname);
		variables.lastname = arguments.lastname;
		variables.firstname = arguments.firstname;
	}
	public function hey(){
		dump("salve #variables.firstname#!");
	}
}
```

2) Calling that getInstance() static function in five times. Here three different arguments for getInstance() function. So displaying three instance while run this on browser. It means same arguments executed at one time only.  

```lucee
// example02.cfm
<cfscript>
	Example2::getInstance("Quintana","Jesus");
	Example2::getInstance("sobchak","walter");
	Example2::getInstance("sobchak","walter");
	Example2::getInstance("sobchak","walter");
	Example2::getInstance("sobchak","walter").hey();
</cfscript>
```

###Example 3:###

1)This example for known the different between the body of instance constructor and static constructor. 

* The static constructor that construct the whole execution when the component is loaded in the memory for first time only.It doesn't create a same instance again for the execution.
* It is created a new instance for every time of execution.

```lucee
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

2) Here we call Example3() function in twice. It displaying three instance while run this on browser in first request. In static constructor body execute one time and instance constructor body execute two times. 

```lucee
// example03.cfm
<cfscript>
	new Example3();
	new Example3();
</cfscript>
```

###Example 4:###

1) This example for known the count of how many instance of the component get loaded. This example we define the body of the static constructor as zero , then increase the count. It act in the instance of component can always access the static scope, because that allows you to share date between multiple instance of the component. 

```lucee
// Example4.cfc
Component {
	static {
		static.counter = 0 ;
	}
	static.counter++ ;
	dump(static.counter&"instances used so far");
}
```

2) Here we call Example4() function in five times. In every time increase the count of counter in static scope. 

```lucee
// example04.cfm 
<cfscript>
	new Example4();
	new Example4();
	new Example4();
	new Example4();
	new Example4();
</cfscript>
```

###Example 5:###

1)  We can also use the static scope to store constant data like HOST,PORT. 

* If we store the instance in variable scope means when you have a thousand components or it will get loaded thousand times, so it is waste of time and memory store. 
* Static scope means that variable example only exist once and independent of how many instance you have, so it's more memory efficient to do it that way and the same you can also do for function in that example.


```lucee
// Example5.cfc
Component {
	static {
		static.HOST = "lucee.org" ;
		static.PORT = 8080 ;
	}
	public static function splitFullName(required string firstname) {
		var arr = listToArray(firstname,"  ");
		return {'lastname':arr[1], 'firstname':arr[2]}; 
	}
	private function init(required string firstname) {
		variables.fullname = static.splitFullName(fullName);
	}
	public string function getLastName() {
		return variables.fullname.lastName ;
	}
}
```

2) Here we call Example5() function in two ways. It has a function splitFullName() is need not to access anything (read or write data from the disks) and variable scope doesn't have to be part of the instance. It returns the firstname and lastname. 

```lucee
// example05.cfm
<cfscript>
	person = new Example5("sobchak walter");
	dump(person.getLastName());

	dump(Example5::splitFullName("Quintana Jesus"));	
</cfscript>
```

### Footnotes ###

Here you can see above details in video

[Lucee Static Scopes in Component Code ](https://www.youtube.com/watch?v=B5ILIAbXBzo&feature=youtu.be)
