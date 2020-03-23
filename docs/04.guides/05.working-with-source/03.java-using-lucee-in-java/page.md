---
title: Using Lucee in Java
id: working-with-source-java-using-lucee-in-java
---

# Using Lucee within Java #
While Lucee allows you to do almost everything your web application will need to do by using CFML code, there may be times when you will need to use Lucee from Java applications.

Since Lucee is written in Java and is running inside a Java Virtual Machine (JVM), using Lucee from your Java applications is very easy.

## Adding Lucee to your Java Project ##

The first thing you will need to do is to add `lucee.jar` to your classpath, so that you will have access to the classes and interfaces that Lucee provides.  if you are using an IDE like Eclipse or Netbeans, then you simply add the `lucee.jar` library to your project.

Once you added `lucee.jar` to your project, you should have access to all of Lucee's public classes and interfaces. In order to access them you will need to add the import statement to the top of your class file.  be sure to add an import statement for each of the classes / interfaces that you plan to use in that class.  you can review the [Lucee JavaDoc files](https://javadoc.lucee.org).

## Using Lucee from your Java code ##
There are two cases in which you might want to use Lucee from your Java code:

* When your Java code is loaded into the JVM through Lucee.
* In a standalone application detached from a Lucee web app.

### When your Java code was loaded by Lucee ###
The easiest way to use Lucee from your Java code is when your Java code was loaded by Lucee.  this is a common case when, for example, your CFML code creates a Java object, and then that Java object creates Lucee objects and calls CFC methods.

Your interaction with Lucee should start via an object that implements the [lucee.loader.engine.CFMLEngine interface](https://javadoc.lucee.org/lucee/loader/engine/CFMLEngine.html) and the [lucee.runtime.PageContext](https://javadoc.lucee.org/lucee/runtime/PageContext.html) object.  Since Lucee loaded your Java code, and it will be running in that very same JVM, you can get a reference to a CFMLEngine object by calling the getInstance() static method of the lucee.loader.engine.CFMLEngineFactory object.

```java
import	lucee.loader.engine.*;
...
public class MyClass {

	CFMLEngine	engine	= CFMLEngineFactory.getInstance();
	PageContext 	pc 	= engine.getThreadPageContext();
	...
}
```

in the following examples in this document "engine" will refer to a lucee.loader.engine.CFMLEngine object, and "pc" will refer to a lucee.runtime.PageContext object.

### When Lucee does not load your Java code ###

**Lucee 5**

With Lucee 5 doing this is a lot easier now.

```java
CFMLEngine engine = CFMLEngineFactory.getInstance();
		// cookies for this simulated request, can also be null
		javax.servlet.http.Cookie[] cookies = new Cookie[]{new Cookie("myCookie","myCookieValue")};

		// headers for this simulated request
		Map<String, Object> headers=new HashMap();
		headers.put("accept","text/html");

		// headers for this simulated request, can also be null
		Map<String, String> parameters=new HashMap();

		// headers for this simulated request, can also be null
		Map<String, Object> attributes=new HashMap();

		PageContext pc = engine.createPageContext(
				 "localhost" // host
				,"/index.cfm" // script name
				,"test=1" // query string
				,cookies
				,headers
				,parameters
				,attributes
				,System.out // response stream where the output is written to
				,50000 // timeout for the simulated request in milli seconds
				,true // register the pc to the thread
				);
		try{
			// use the pc
		}
		finally{
			engine.releasePageContext(pc, true/* unregister the pc from the thread*/);
		}
```

## Using the Lucee objects from Java ##

once you have a reference to the CFMLEngine and the PageContext objects, you can easily interact with Lucee from your code.  here is an example on how to get / set Lucee values from within your Java code:

```java
// get a reference to the Application Scope:
Scope	appScope	=	pc.applicationScope();

// get a value from the Application Scope:
String	appName1	=	appScope.get( "ApplicationName" );

// you can also get the value from the PageContext directly:
String	appName2	= 	pc.getVariable( "Application.ApplicationName" );

if ( !appName1.equals( appName2 ) )
	throw CFMLEngineFactory.getInstance().getExceptionUtil().createApplicationException( "WTF?!@#" );
```

you can also set variables in a similar manner:

```java
// this is the Java equivalent of <cfset Application.javaTime = getTickCount()>
pc.setVariable( "Application.javaTime", System.currentTimeMillis() );
```

then in your CFML code, you can use this value like so:

```lucee
<cfoutput>The Tick Count set from Java was: #Application.javaTime#</cfoutput>
```

in the same way you can get a reference to other objects in the different scopes.  for example, if in onApplicationStart() (of  Application.cfc) your Lucee code creates somewhere a component and sets a reference to it in Application.myCfc

```lucee
<cffunction name="onApplicationStart">

	<cfset Application.myCfc = createObject( "component", "my.lib.Comp" )>
</cffunction>
```

then you can get a reference to it in Java like this:

```java
Component cfc = (Component) pc.getVariable( "Application.myCfc" );

if ( cfc != null ) {
	... do something with cfc ...
}
```

alternatively, if you want to create a new CFC in your Java code, you can use the PageContext's loadComponent method:

```java
// this will cause Lucee to search it's component mapping paths for my.lib.Comp and create a new component
Component cfc = pc.loadComponent( "my.lib.Comp" );

// set it to a variable in the Application scope
pc.setVariable( "Application.myCfc", cfc );
```

### Calling CFC Methods from Java ###

once you have a reference to a CFC you can invoke its methods by using the call() or callWithNamedValues() methods:

#### calling method with no arguments ####
```java
// call the CFC's funcation getLastName with no args (empty array):
String lastName = (String) cfc.call( pc, "getLastName", new Object[0] );
```

#### calling method with ordered arguments ####
```java
// execute the cfc with ordered arguments
cfc.call( pc, "setLastName", new Object[]{ "Smith" } );
```

#### calling method with named arguments ####
```java
// execute the cfc with named arguments
Struct	args	=	engine.getCreationUtil().createStruct();
args.set( "name", "Smith" );
cfc.callWithNamedValues( pc, "setLastName", args );
```


## Other Useful Methods of the PageContext class ##

#### Get Lucee Scopes ####
```java
Scope varialbesScope	= pc.variablesScope();

Scope requestScope	= pc.requestScope();

Scope sessionScope	= pc.sessionScope();

Scope applicationScope	= pc.applicationScope();
```

### Get/Set Variables ###
```java
// get variable by using its fully qualified name
String username = (String) pc.getVariable( "session.username" );

// set variable by using its fully qualified name
pc.setVariable( "session.username", "Susanne" );

// get variable from scope obtained earlier
String username = (String) sessionScope.get( "username" );

// set variable in scope obtained earlier
sessionScope.set( "username", "Susanne" );
```
(of course, as with your CFML code, you should only set values to shared objects in a synchronized manner)
### Create CF Objects ###
```java
// get a reference to the creation utility class
Creation	creationUtil		=	engine.getCreationUtil();

// create CF Array
lucee.runtime.type.Array cfArray	=	creationUtil.createArray();

// create CF Struct
lucee.runtime.type.Struct cfStruct	=	creationUtil.createStruct();

// create CF Query named qNames with two columns (firstName and lastName) and 1 row
lucee.runtime.type.Query cfQuery	=	creationUtil.createQuery( new String[]{ "firstName","lastName" }, 1, "qNames" );
```

### Decision Util ###
```java
Decision decisionUtil = engine.getDecisionUtil();

if ( decisionUtil.isDate( obj, false ) || decisionUtil.isStruct( obj ) );
```

### Operations Util ###
```java
Operation opUtil = engine.getOperatonUtil();
int c = opUtil.compare( left, right );	// cfml comparison rules
if ( c < 0 ) {
	// negative value = "left" is Less Than "right"
} else if ( c > 0 ) {
	// positive value = "left" is Greater than "right"
} else {
	// zero = "left" Equals "right"
}
```

### Casting ###
```java
Cast castUtil	=	engine.getCastUtil();
castUtil.toArray( obj );
castUtil.toStruct( obj );
```

### Exceptions Util ###
```java
Excepton exp = engine.getExceptionUtil();

if ( doAbort )
	throw exp.createAbort();
else
	throw exp.createApplicationException( "this is wrong", "you cannot ..." );
```

### Evaluate ###
```java
Object	obj =	pc.evaluate( "url.test=len( 'Lucee is awesome!' )" );	// same as function evaluate(string)
```

#### Serialize ####
```java
String str = pc.serialize( obj ); // same as function serialize(object)
```
