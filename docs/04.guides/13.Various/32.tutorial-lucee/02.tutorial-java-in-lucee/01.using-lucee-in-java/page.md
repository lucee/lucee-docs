---
title: Using Lucee in Java
id: using-lucee-in-java
---

while Lucee allows you to do almost everything your web application will need to do by using CFML code, there may be times when you will need to use Lucee from Java applications.

since Lucee is written in Java, and is running inside a Java Virtual Machine (JVM), using Lucee from your Java applications is very easy.

### Adding Lucee to your Java Project ###

The first thing you will need to do is to add lucee.jar to your classpath, so that you will have access to the classes and interfaces that Lucee provides. if you are using an IDE like Eclipse or Netbeans, then you simply add the lucee.jar library to your project.

Once you added lucee.jar to your project, you should have access to all of Lucee's public classes and interfaces. in order to access them you will need to add the import statement to the top of your class file. be sure to add an import statement for each of the classes/interfaces that you plan to use in that class. you can review the [Lucee javadoc](https://javadoc.lucee.org/).

### Using Lucee from your Java code ###

there are two cases in which you might want to use Lucee from your Java code:

1. when your Java code is loaded into the JVM through Lucee
1. in a standalone application detached from a Lucee web app

### when your Java code was loaded by Lucee ###

the easiest way to use Lucee from your Java code is when your Java code was loaded by Lucee. this is a common case when, for example, your CFML code creates a Java object, and then that Java object creates Lucee objects and calls CFC methods.

your interaction with Lucee should start via an object that implements the lucee.loader.engine.CFMLEngine interface

[lucee.loader.engine.CFMLEngine](https://javadoc.lucee.org/lucee/loader/engine/CFMLEngine.html) and the [lucee.runtime.PageContext](https://javadoc.lucee.org/lucee/runtime/PageContext.html) object.

Since Lucee loaded your Java code, and it will be running in that very same JVM, you can get a reference to a CFMLEngine object by calling the getInstance() static method of the lucee.loader.engine.CFMLEngineFactory object.

```lucee
import	lucee.loader.engine.*;
...

public class MyClass {

	CFMLEngine	engine	= CFMLEngineFactory.getInstance();
	PageContext 	pc 	= engine.getThreadPageContext();
	...
}
```

in the following examples in this document "engine" will refer to a lucee.loader.engine.CFMLEngine object, and "pc" will refer to a lucee.runtime.PageContext object.

### when Lucee does not load your Java code ###

when you want to use Lucee from Java in a detached environment, i.e. Lucee does not load your Java code -- it is a little more complicated to access Lucee, as you will have to create the CFMLEngine and the PageContext objects yourself.

due to the complexity involved this is beyond the scope of this document. please consult the code written for Lucee CLI in Version 4.0 Alpha and see how it is used there:

<https://github.com/lucee/Lucee/blob/5.2/loader/src/main/java/lucee/cli/CLI.java>
and in the cli() method of CFMLEngineImpl (line 541 at the time of writing):

<https://github.com/lucee/Lucee/blob/5.2/core/src/main/java/lucee/runtime/engine/CFMLEngineImpl.java>

### Using the Lucee objects from Java ###

once you have a reference to the CFMLEngine and the PageContext objects, you can easily interact with Lucee from your code. here is an example on how to get / set Lucee values from within your Java code:

```lucee
// get a reference to the Application Scope:
Scope	appScope	=	pc.applicationScope();

// get a value from the Application Scope:
String	appName1	=	appScope.get( "ApplicationName" );

// you can also get the value from the PageContext directly:
String	appName2	= 	pc.getVariable( "Application.ApplicationName" );

if ( !appName1.equals( appName2 ) )
	throw new ApplicationException( "WTF?!@#" );
```

you can also set variables in a similar manner:

```lucee
// this is the Java equivalent of <cfset Application.javaTime = getTickCount()>
pc.setVariable( "Application.javaTime", System.currentTimeMillis() );
```

then in your CFML code, you can use this value like so:

	<cfoutput>The Tick Count set from Java was: #Application.javaTime#</cfoutput>

in the same way you can get a reference to other objects in the different scopes. for example, if in onApplicationStart() (of Application.cfc) your Lucee code creates somewhere a component and sets a reference to it in Application.myCfc

```lucee
<cffunction name="onApplicationStart">
	<cfset Application.myCfc = createObject( "component", "my.lib.Comp" )>
</cffunction>
```

then you can get a reference to it in Java like this:

```lucee
Component cfc		= 	(Component) pc.getVariable( "Application.myCfc" );

if ( cfc != null ) {

	... do something with cfc ...
}
```

alternatively, if you want to create a new CFC in your Java code, you can use the PageContext's loadComponent method:

```lucee
// this will cause Lucee to search it's component mapping paths for my.lib.Comp and create a new component
Component cfc		= 	pc.loadComponent( "my.lib.Comp" );

// set it to a variable in the Application scope
pc.setVariable( "Application.myCfc", cfc );
```

Calling CFC Methods from Java

once you have a reference to a CFC you can invoke its methods by using the call() or callWithNamedValues() methods:

### calling method with no arguments ###

```lucee
// call the CFC's function getLastName with no args (empty array):
String lastName = (String) cfc.call( pc, "getLastName", new Object[0] );
```

calling method with ordered arguments

```lucee
// execute the cfc with ordered arguments
cfc.call( pc, "setLastName", new Object[]{ "Smith" } );
```

calling method with named arguments

```lucee
// execute the cfc with named arguments
Struct	args	=	engine.getCreationUtil().createStruct();
args.set( "name", "Smith" );
cfc.callWithNamedValues( pc, "setLastName", args );
```

Other Useful Methods of the PageContext class

Get Lucee Scopes

	Scope varialbesScope	= pc.variablesScope();

	Scope requestScope	= pc.requestScope();

	Scope sessionScope	= pc.sessionScope();

	Scope applicationScope	= pc.applicationScope();

Get/Set Variables

	// get variable by using its fully qualified name
	String username = (String) pc.getVariable( "session.username" );

	// set variable by using its fully qualified name
	pc.setVariable( "session.username", "Susanne" );

	// get variable from scope obtained earlier
	String username = (String) sessionScope.get( "username" );

	// set variable in scope obtained earlier
	sessionScope.set( "username", "Susanne" );

(of course, as with your CFML code, you should only set values to shared objects in a synchronized manner)

Create CF Objects

	// get a reference to the creation utility class
	Creation	creationUtil		=	engine.getCreationUtil();

	// create CF Array
	lucee.runtime.type.Array cfArray	=	creationUtil.createArray();

	// create CF Struct
	lucee.runtime.type.Struct cfStruct	=	creationUtil.createStruct();

	// create CF Query named qNames with two columns (firstName and lastName) and 1 row
	lucee.runtime.type.Query cfQuery	=	creationUtil.createQuery( new String[]{ "firstName","lastName" }, 1, "qNames" );

Decision Util

	Decision decisionUtil = engine.getDecisionUtil();

	if ( decisionUtil.isDate( obj, false ) || decisionUtil.isStruct( obj ) );

Operations Util

	Operation opUtil = engine.getOperatonUtil();
	int c = opUtil.compare( left, right );	// cfml comparison rules
	if ( c < 0 ) {
		// negative value = "left" is Less Than "right"
	} else if ( c > 0 ) {
		// positive value = "left" is Greater than "right"
	} else {
		// zero = "left" Equals "right"
	}

Casting

	Cast castUtil	=	engine.getCastUtil();
	castUtil.toArray( obj );
	castUtil.toStruct( obj );

Exceptions Util

	Exception exp = engine.getExceptionUtil();

	if ( doAbort )
		throw exp.createAbort();
	else
		throw exp.createApplicationException( "this is wrong", "you cannot ..." );

Evaluate

	Object	obj =	pc.evaluate( "url.test=len( 'Lucee is awesome!' )" );	// same as function

Serialize

(new in Lucee 4.0)

	String	str =	pc.serialize( obj ); // same as function serialize(object)
