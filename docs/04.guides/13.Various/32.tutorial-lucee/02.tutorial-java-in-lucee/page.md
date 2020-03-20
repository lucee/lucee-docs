---
title: Using Java in Lucee
id: tutorial-using-java-in-lucee
categories:
- java
---

### Do you really need Java? ###

Before you start creating Java objects in Lucee you should ask yourself: Do I really need Java here or can I get the same result with CFML alone? It's been said in computing that "premature optimization is the root of all evil" and Sean will (rightfully) remind you that "perfection is the enemy of the good", so if you can achieve similar results without referring to Java objects -- please stick to CFML path.

### When should you use Java? ###

Having said that, there are some instances where it makes sense to use Java objects directly:

* you want to use a library that was written in Java
* you must optimize a bottleneck segment of code for speed

In this tutorial I will focus on the first reason for using Java. there are many projects written in Java (many of them are open-source) that can add a lot of functionality to your application and save you a lot of time in writing, testing, and debugging. so instead of "reinventing the wheel" and writing your own code to achieve a task, it makes sense to utilize one of these projects.

### How to use Java? ###

Since Lucee is written in Java, and is running inside a Java Virtual Machine (JVM), using Java from Lucee is as simple as 1-2-3:

1. Check out the API of the objects you plan to use -- you have to know which methods and properties are available for you from your application.
2. Get a reference to Java object(s) in CFML via the createObject( "java", objectType ) function.
3. Use the Java object(s).

### Step 1 - Check out the API ###

the PI in API stands for Public Interface. Public Interface defines the methods (functions) and properties that are exposed publicly. these are the methods and properties that the designers of the object or library decided to make public for your use.

in order to interact with an object that someone else wrote you have to study the API for that object. fortunately, most objects that are intended for someone else's (like yourself) use come with documentation.

### Step 2 - Get a reference to Java object(s) from CFML ###

in most cases you will want to call one or more methods (functions) of the objects that you use. in order to call a method you must first define the object in CFML so that Lucee will know on which object you want to call the method.

in order to define an object, you must ensure that the object is "visible" to Lucee. if the object is of a type that's included with the Java Runtime Environment (JRE), then it is visible and you don't have to do anything else. but if you are using an object from another project then you must ensure that the Java Archive (JAR) file(s) are in one of the paths that are visible to Lucee.

some of the paths include:

* {lucee-server}/WEB-INF/lib
* {website-root}/WEB-INF/lucee/lib

### Getting a Reference to an Object ###

Now you are ready to define the object so that it's accessible to your code. you do that with the createObject( "java", objectType ) function. the objectType is the fully qualified name of the object, meaning it should have the package path as well the class name.

you will want to set the reference to a variable so that you can use it later. for example, to create a reference to the class Collections class in the java.util package, you will use:

	<cfset classCollections = createObject( "java", "java.util.Collections" )>

this will create a reference to the java.util.Collections class and keep it in a CFML variable named classCollections.

please note that "createObject" is a misnomer and at this point you did not create an object yet. createObject( "java", ... ) is in fact equivalent to the Java import statement, so in Java the line above is read as:

	import java.util.Collections;


**Creating a new Object**

Usually you create an instance of an object by calling its constructor.
in Java this is done by using the new keyword. for example:

	myList = new java.util.ArrayList();

In CFML, you use the init() method to call the constructor, so the equivalent to the statement above will be:

	<cfset myList = createObject( "java", "java.util.ArrayList" ).init()>

I say "usually you create an instance by calling its constructor" because some objects do not expose a public constructor, but instead let you to create an instance by calling a static method. the API should explain how to create a new object in such a case.

Sometimes you need to pass arguments to a constructor, you do that the same way you pass arguments to any method and I will show that below.

**Inner Classes**

when you need to use an Inner Class, that is a class that is defined within another class in Java, the last part of the fully qualified class name is delimited by a $ sign rather than a dot. see example below in the Lucene BooleanClause segment.

### Step 3 - Use the Java object(s) ###

Once you define/create the Java objects you can use them by calling their methods from ColdFusion.

**Calling Methods**

There are two types of methods in Java:

* Static Methods
* Instance Methods

The API will tell you whether the methods that you want to use are static or not (any method that's not a static method is an instance method).

The thing that you need to remember is that if a method is an instance method then you need to first create a new instance of the object (or get a reference to an existing instance).

The following example creates a new instance of a java.util.ArrayList object, and then calls the instance method add() several times. then it defines a reference to the java.util.Collections, and calls the static method sort( List ). notice that we don't call init() on java.util.Collections since we're calling a static method. as a matter of fact, if you check out the API for java.util.Collections [http://download.oracle.com/javase/7/docs/api/java/util/Collections.html](http://download.oracle.com/javase/7/docs/api/java/util/Collections.html) you will see that it does not have a constructor.

```lucee
<cfset myList = createObject( "java", "java.util.ArrayList" ).init()>	<!--- create new instance --->

<cfset myList.add( "item one" )>	<!--- call instance method add( Object ) --->
<cfset myList.add( "item 2" )>
<cfset myList.add( "3rd item" )>
<cfset myList.add( "just one more" )>

<cfset createObject( "java", "java.util.Collections" ).sort( myList )>	<!--- call static method sort( List ) --->
```

### Passing Arguments to Methods ###

Unlike ColdFusion, Java is a strongly typed language, meaning that if a variable is expected to be of a certain type -- it Must be of that type (or of a type that has a "is a" relationship of that type).

What this means is that if a method expects an argument to be of a certain type -- it Must be of that type. you can enforce the types passed to methods by using CFML's javaCast( type, variable ) function.

Consider the following scenario: you have a Java method that expects an argument of type Integer. let's say the the method's signature is as follows:

```lucee
public void add( int value ) { ... }
```

This method signature is read as "a public function that takes an Integer (int) returns no result (void)".

Assume you have created an object of that type and it's reference via the CF variable myObject.

If you try something like:

```lucee
<cfset number = 10>
<cfset myObject.add( number )>
```

chances are that you'll get an error when the code reaches the call to the add() method. The reason is that Java expects the variable to be of type Integer, but CF by default assigns numerical variables to the type Double.

You can fix this by forcing CF to pass the argument as an Integer.

	<cfset myObject.add( javaCast( "integer", number ) )>

**Data Types**

In addition to the simple CF types, you will likely see many times that you have to pass complex types to/from Java. the most popular types are Collection, List, and Map. the table below shows the equivalent CF type to these Java types:

**Java Type**

**Lucee Type**
```lucee
<tr>
	<td>java.util.Collection
	<td>Array

<tr>
	<td>java.util.List
	<td>Array

<tr>
	<td>java.util.Map
	<td>Struct

<tr>
	<td>javax.servlet.http.HttpServletRequest
	<td>getPageContext().getHttpServletRequest()

<tr>
	<td>javax.servlet.http.HttpServletResponse
	<td>getPageContext().getHttpServletResponse()
```

**Receiving Values from Methods**

If a Java method returns a value, then receiving it is straight forward.

Say that the method's signature of an object named myObject is

	public int add( int value ) { ... }

then calling

	<cfset newValue = myObject.add( javaCast( "integer", 10 ) )>

will assign the result of the method call to the variable newValue.

**Example - creating a Lucene objects**

For example, let's say that you want to use the Lucene project from your code. (fortunately, you can use Lucene directly from Lucee thanks to the Lucee Built-in Search), but this can still be a good example.

The first thing to do would be to check the Lucene API docs at http://lucene.apache.org/java/3_3_0/api/all/index.html

Let's say that you want to create an instance of Lucene's StandardAnalyzer so you can "analyze" text from your CFML code.

Check out StandardAnalyzer's API at http://lucene.apache.org/java/3_3_0/api/all/org/apache/lucene/analysis/standard/StandardAnalyzer.html

Perusing the Constructor Summary, you will notice that the StandardAnalyzer class does not have a no-argument constructor, so you can't just call .init() on the object -- you must pass some argument to it.

The simplest constructor to use, using the default "stop words" is -- StandardAnalyzer( Version matchVersion ) -- and it expects a Version argument. the Version argument is an Enum type http://lucene.apache.org/java/3_3_0/api/all/org/apache/lucene/util/Version.html, so you can not simply pass a string into the StandardAnalyzer's constructor -- that would not work!

So in order to call the StandardAnalyzer's constructor you must first get a reference to an org.apache.lucene.util.Version object.

One way of getting a reference to Version type is:

	<cfset Lucene.version = createObject( "java", "org.apache.lucene.util.Version" ).LUCENE_33>

Notice that the object's type is org.apache.lucene.util.Version and Not ~~org.apache.lucene.util.Version.LUCENE_33~~ so you can not do <cfset Lucene.version = createObject( "java", "org.apache.lucene.util.Version.LUCENE_33" )> as that is not a valid type. what you do is create a reference to org.apache.lucene.util.Version and then use a property of that reference with a dot notation, i.e. ".LUCENE_33"

The problem with this construct is that it forces version to be hard-coded as LUCENE_33. but what if you don't want to hard-code the version? what if you want to get it from a settings file, or get it via an argument to your own cfc or method?

Since the Version type is an Enum, it has a valueOf( String ) method. we can pass a string into that method and get a reference to the Version object that we can then pass to the StandardAnalyzer's constructor.

```lucee
<cfset versionName = "LUCENE_33">
<cfset Lucene.version = createObject( "java", "org.apache.lucene.util.Version" ).valueOf( versionName )>
```

Regardless of how you obtained a reference to the Version object, you can now pass it to the StandardAnalyzer's constructor:

```lucee
<cfset Lucene.standardAnalyzer = createObject( "java", "org.apache.lucene.analysis.standard.StandardAnalyzer" ).init( Lucene.version )>
```

If you will use Lucene to filter results, you will likely need to use the BooleanClause.Occur to specify compounded filters.

Because Occur is an Inner Class of BooleanClause, you will need to reference it via the $ delimiter as mentioned above, so the full path for the Occur inner class is org.apache.lucene.search.BooleanClause$Occur

```lucee
<cfset objBooleanClauseOccur		= createObject( "java", "org.apache.lucene.search.BooleanClause$Occur" )>
<cfset Lucene.BooleanClause.MUST	= objBooleanClauseOccur.MUST>
<cfset Lucene.BooleanClause.MUST_NOT	= objBooleanClauseOccur.MUST_NOT>
<cfset Lucene.BooleanClause.SHOULD	= objBooleanClauseOccur.SHOULD>
```

Again, we first create a reference to the class, org.apache.lucene.search.BooleanClause$Occur, and then retrieve its properties.

Example - using the SocialAuth library

See API at [http://code.google.com/p/socialauth/](http://code.google.com/p/socialauth/)

this example is based on the getting started example at
[http://code.google.com/p/socialauth/wiki/GettingStartedWithYourOwnFramework](http://code.google.com/p/socialauth/wiki/GettingStartedWithYourOwnFramework)

Java example code in API:

```lucee
//Create an instance of SocialAuthConfig object
SocialAuthConfig config = SocialAuthConfig.getDefault();

//load configuration. By default load the configuration from oauth_consumer.properties.
//You can also pass input stream, properties object or properties file name.
config.load();

//Create an instance of SocialAuthManager and set config
SocialAuthManager manager = new SocialAuthManager();
manager.setSocialAuthConfig(config);

// URL of YOUR application which will be called after authentication
String successUrl= "http://opensource.brickred.com/socialauthdemo/socialAuthSuccessAction.do";

// get Provider URL to which you should redirect for authentication.
// id can have values "facebook", "twitter", "yahoo" etc. or the OpenID URL
String url = manager.getAuthenticationUrl(id, successUrl);

// Store in session
session.setAttribute("authManager", manager);
```
Ported to CFML:

```lucee
<cfset config = createObject( "java", "org.brickred.socialauth.SocialAuthConfig" ).getDefault()>
<cfset config.load()>

<cfset manager = createObject( "java", "org.brickred.socialauth.SocialAuthManager" ).init()>
<cfset manager.setSocialAuthConfig( config )>

<cfset successUrl = "http://yourwebsite.org/socialAuthSuccessAction.cfm">

<cfset redirUrl = manager.getAuthenticationUrl( id, successUrl )>  <!--- need to set id somewhere --->

<cfset session.authManager = manager>

<cflocation url="#redirUrl#">
```

then at [http://yourwebsite.org/socialAuthSuccessAction.cfm](http://yourwebsite.org/socialAuthSuccessAction.cfm)

Java example code in API:

```lucee
// get the social auth manager from session
SocialAuthManager manager = (SocialAuthManager)session.getAttribute("authManager");

// call connect method of manager which returns the provider object.
// Pass request parameter map while calling connect method.
AuthProvider provider = manager.connect(SocialAuthUtil.getRequestParametersMap(request));

// get profile
Profile p = provider.getUserProfile();

// you can obtain profile information
System.out.println(p.getFirstName());

// OR also obtain list of contacts
List<Contact> contactsList = provider.getContactList();
```

Ported to CFML:

```lucee
<cfset manager = session.authManager>

<cfset provider = manager.connect( SocialAuthUtil.getRequestParametersMap( getPageContext().getHttpServletRequest() ) )>

<cfset p = provider.getUserProfile()>

<cfoutput>#p.getFirstName()#</cfoutput>

<cfset contactsList = provider.getContactList()>

<cfdump var="#contactsList#">
```

### Troubleshooting ###

Class Not Found

If you get an error that says: `Object Instantiation Exception: Class not found` then Lucee was unable to find your class.

You should:

* ensure that the JAR file that contain that class is in the classpath, i.e. "visible" to Lucee
* make sure that you typed correctly (cAsE sensitive!) the fully qualified class name

### cAsE sEnSiTiViTy ###

Java is case-sensitive, so `java.util.ArrayList` and `java.util.arraylist` are different, and if you use the wrong casing -- your code will break.

### Collections are usually 0-based ###

In ColdFusion the Array object's first element is found at the 1-index. In most Java collections the first element is at the 0-index.

### Concrete Implementations different from what you Expect ###

Many times the return value of a method is an Interface type, rather than a concrete type.

If you use that value later and its implementation is different than you expect -- you might run into trouble.

For example, imagine you have a method that returns a java.util.Map object. java.util.Map is a Java interface, and therefore the actual type of object returned can be one of many.

So if you try to use the returned object as a ColdFusion Struct, chances are that you'll not get the results you expect. the reason is that in ColdFusion Structs the keys are case insensitive, where as in most other implementations a Map the keys are cAsE sensitive.

So if the returned Map object has a key named "Name", and you will try to reference it as myMap.Name you will likely get an error as behind the scenes Lucee will try to reference it as myMap.NAME which does not exist in a cAsE sensitive Map.

You will still be able to get the value by calling myName[ "Name" ] which preserves the key's case.

### Inspect the object with CFDUMP ###

You can always use cfdump on a Java object to see what methods and properties are available. this is very useful when trying to troubleshoot a problem.


	<cfdump var="#myJavaObject#">

See also: [[using-lucee-in-java]]
