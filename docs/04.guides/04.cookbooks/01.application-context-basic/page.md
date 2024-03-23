---
title: Create an Application.cfc
id: cookbook-application-context-basic
related:
- tag-application
categories:
- application
description: How to create and configure the Application.cfc
---

# Application.cfc #

The Application.cfc is a component you put in your web application that then is picked up by Lucee as part of the request.
The Application.cfc is used to define context specific configurations/settings and event driven functions.
Your website can have multiple Application.cfc files, every single file then defines an independent application context.

Let's say you have a website that has a shop under the path "/shop" that needs user sessions, but the rest of the website does not.
In that case you could define an Application.cfc at "/shop" that has session handling enabled and one in the webroot that has not.

## Location, Location, Location ##

With the default setting Lucee always picks the "nearest" Application.cfc, so it searches from the current location down to the webroot.
This is only one possible behavior of many, Lucee gives you the possibility in the Lucee Administrator under "Settings / Request" to decide where Lucee looks for the Application.cfc and if it looks at all.

![search mode](https://bitbucket.org/repo/rX87Rq/images/3223743265-APP-SEARCH-MODE.png)

So, for example, if you only have one Application.cfc in the webroot, define "Root" as setting.

## Functions ##

The Application.cfc supports multiple event driven functions, what does this mean?
You can define functions inside the Application.cfc that are called when certain events happen.

### OnApplicationStart ###

This function is triggered when no application context exists for this Application.cfc, so normally when the first request on this application context is made.

```cfs
component {
   boolean function onApplicationStart() {
      application.whatever=new Whatever(); // init whatever
   }
}
```

This is normally used to initialize the environment for your application, so for example load data/objects and store them in the application scope.
if the function returns false or throws an exception, the application context is not initialized and the next request will call "onApplicationStart" again. "onApplicationStart" is thread safe.

### OnApplicationEnd ###

The opposite from "onApplicationStart", this function is triggered when the application context ends, means when the timeout of the application context is reached (this.applicationTimeout).

```cfs
component {
   void function onApplicationEnd(struct application) {
      arguments.application.whatever.finalize();
   }
}
```

This is normally used to finalize the environment of your application, so for example unload data/objects.
You receive the application scope that ends as an argument to the function.

### OnSessionStart ###

This function is triggered with every request that has no session defined in the current application context.

```cfs
component {
   void function onSessionStart() {
      session.whatever=new Whatever(session.cfid); // init whatever
   }
}
```

This is normally used to initialize the environment for a specific session, so for example load data/objects and store them in the session scope.

### OnSessionEnd ###

The opposite from "onSessionStart", this function is triggered when a specific session context ends, when the timeout of a session context is reached (this.sessionTimeout). 

Irrespective of the exact `sessionTimeout` value, `onSessionEnd` is called when the background controller thread cleans up expired scopes (i.e. `session`, `application`), by default, this process runs every minute.

```cfs
component {
   void function onSessionEnd(struct session,struct application) {
      arguments.session.whatever.finalize();
   }
}
```

This is normally used to finalize the environment of your application, so for example unload data/objects.
You receive the related application scope and the session scope that ends, as arguments to the function.

### OnRequestStart ###

This function is triggered before every request, so you can prepare the environment for the request, for example to produce the HTML header or load some data/objects used within the request.

```cfs
component {
   boolean function onRequestStart(string targetPage) {
       echo('<html><head><body>'); // outputs the response HTML header
       request.whatever=new Whatever(); // prepare an object to use within the request
       return true;
   }
}
```

If the function returns false, Lucee stops any further execution of this request and return the result to the client.

### OnRequestEnd ###

This function is triggered after every request, so you can cleanup the environment after the request, for example produce the HTML footer or unload some data/objects used within the request.

```cfs
component {
   void function onRequestEnd(string targetPage) {
       echo('</body></html>'); // outputs the response HTML footer
       request.whatever.finalize();
   }
}
```

### OnRequest ###

If this function exists, Lucee only executes this function and no longer looks for the "targetPage" defined with the request.
So let's say you have the call "/index.cfm", if there is an "/index.cfm" in the file system or not, does not matter, it is not executed anyway.

**Other CFML Engines will complain when the called target page does not exist physically even it is never used!**

```cfs
component {
   void function onRequest(string targetPage) {
       echo('<html><body>Hello World</body></html>');
   }
}
```

### OnCFCRequest ###

Similar to "onRequest", but this function is used to handle remote component calls (HTTP Webservices).

```cfs
component {
   void function onCFCRequest(string cfcName, string methodName, struct args) {
       echo('<html><body>Hello World</body></html>');
   }
}
```

### OnError ###

This method is triggered when an uncaught exception occurs in this application context.

```cfs
component {
   void function onError(struct exception, string eventName) {
       dump(var:exception,label:eventName);
   }
}
```

As arguments you receive the exception (cfcatch block) and the eventName.

### OnAbort ###

This method is triggered when a request is ended with help of the tag <cfabort>.

```cfs
component {
   void function onAbort(string targetPage) {
       dump("request "&targetPage&" ended with an abort!");
   }
}
```

### OnDebug ###

This method is triggered when debugging is enabled for this request.

```cfs
component {
   void function onDebug(struct debuggingData) {
       dump(var:debuggingData,label:"debug information");
   }
}
```

### OnMissingTemplate ###

This method is triggered when a requested page was not found and **no function "onRequest" is defined **.

```cfs
component {
   void function onMissingTemplate(string targetPage) {
       echo("missing:"&targetPage);
   }
}
```

## Application.cfc Default Template ##

Below you can find an Application.cfc template that may serve as a starting point for your own applications settings with Lucee CFML engine. 

When creating an Application.cfc for the first time, you can configure all the settings within the Lucee Server or Web Administrator and use its "Export" tool ( Lucee Adminisitrator => Settings => Export )  to move (by copy and paste) the settings to your Application.cfc.

```cfs
component displayname="Application" output="false" hint="Handle the application" {

         
    /***************************************************************************
    * INTRODUCTION
    ****************************************************************************
    *  This Application.cfc template should serve as a 
    *  starting point for your applications settings running
    *  with Lucee CFML engine. 
    * 
    *  The settings/definitions are set as comments and represent Lucees default
    *  settings. Some settings/definitions should only serve as helping 
    *  examples, e.g. datasources, mailservers, cache, mappings
    *
    *  When creating an Application.cfc for the first time, you can configure 
    *  all the settings within the Lucee Server or Web Administrator 
    *  and use its "Export" tool ( Lucee Adminisitrator => Settings => Export )  
    *  to move (by copy and paste) the settings to your Application.cfc.
    * 
    *  For further reference please see the following documentation at:
    *  https://docs.lucee.org/categories/application.html
    *  https://docs.lucee.org/guides/cookbooks/application-context-basic.html
    *  https://docs.lucee.org/reference/tags/application.html
    *  https://docs.lucee.org/guides/Various/system-properties.html
    * 
    ***************************************************************************/




   ////////////////////////////////////////////////////////////////
   //  APPLICATION NAME
   //  Defines the name of your application
   ////////////////////////////////////////////////////////////////
   // this.name = "myApplication";

   ////////////////////////////////////////////////////////////////
   //  LOCALE
   //  Defines the desired time locale for the application
   ////////////////////////////////////////////////////////////////
   // this.locale = "en_US"; 

   ////////////////////////////////////////////////////////////////
   //  TIME ZONE
   //  Defines the desired time zone for the application
   ////////////////////////////////////////////////////////////////
   // this.timezone = "Europe/Berlin"; 


   ////////////////////////////////////////////////////////////////
   //  WEB CHARSET
   //  Default character set for output streams, form-, url-, and 
   //  cgi scope variables and reading/writing the header
   ////////////////////////////////////////////////////////////////
   // this.charset.web="UTF-8";


   ////////////////////////////////////////////////////////////////
   //  RESOURCE CHARSET
   //  Default character set for reading from/writing to 
   //  various resources
   ////////////////////////////////////////////////////////////////
   // this.charset.resource="windows-1252";
   

   ////////////////////////////////////////////////////////////////
   //  APPLICATION TIMEOUT
   //  Sets the amount of time Lucee will keep the application scope alive. 
   ////////////////////////////////////////////////////////////////
   //  this.applicationTimeout = createTimeSpan( 1, 0, 0, 0 ); 


   ////////////////////////////////////////////////////////////////
   //  SESSION TYPE
   //  Defines the session engine 
   //  - Application: Default cfml sessions
   //  - JEE: JEE Sessions allow to make sessions over a cluster. 
   ////////////////////////////////////////////////////////////////
   // this.sessionType = "application"; 


   ////////////////////////////////////////////////////////////////
   //  SESSION MANAGEMENT
   //  Enables/disables session management
   ////////////////////////////////////////////////////////////////
   // this.sessionManagement = true;
   
   
   ////////////////////////////////////////////////////////////////
   //  SESSION TIMEOUT
   //  Sets the amount of time Lucee will keep the session scope alive. 
   ////////////////////////////////////////////////////////////////
   // this.sessionTimeout = createTimeSpan( 0, 0, 30, 0 ); 


   ////////////////////////////////////////////////////////////////
   //  SESSION STORAGE
   //   Default Storage for Session, possible values are:
   //  - memory: the data are only in the memory, so in fact no persistent storage
   //  - file: the data are stored in the local filesystem
   //  - cookie: the data are stored in the users cookie
   //  - <cache-name>: name of a cache instance that has "Storage" enabled
   //  - <datasource-name>: name of a datasource instance that has "Storage" enabled
   ////////////////////////////////////////////////////////////////
   // this.sessionStorage = "memory"; 


   ////////////////////////////////////////////////////////////////
   //  CLIENT MANAGEMENT
   //  Enables/disables client management
   ////////////////////////////////////////////////////////////////
   // this.clientManagement = false; 


   ////////////////////////////////////////////////////////////////
   //  CLIENT COOKIES
   //  Enables/disables client cookies
   ////////////////////////////////////////////////////////////////
   // this.setClientCookies = true;
   
   
   ////////////////////////////////////////////////////////////////
   //  CLIENT TIMEOUT
   //  Sets the amount of time Lucee will keep the client scope alive.
   ////////////////////////////////////////////////////////////////
   // this.clientTimeout = createTimeSpan( 90, 0, 0, 0 );
   
   
   ////////////////////////////////////////////////////////////////
   //  CLIENT STORAGE
   //  Default Storage for Session, possible values are:
   // - memory: the data are only in the memory, so in fact no persistent storage
   // - file: the data are stored in the local filesystem
   // - cookie: the data are stored in the users cookie
   // - <cache-name>: name of a cache instance that has "Storage" enabled
   // - <datasource-name>: name of a datasource instance that has "Storage" enabled
   ////////////////////////////////////////////////////////////////
   // this.clientStorage = "cookie";

   
   ////////////////////////////////////////////////////////////////
   //  DOMAIN COOKIES
   //  Enables or disables domain cookies. 
   ////////////////////////////////////////////////////////////////
   // this.setDomainCookies = false; 
   

   ////////////////////////////////////////////////////////////////
   //  CGI READ ONLY 
   //  Defines whether the CGI Scope is read only or not.
   ////////////////////////////////////////////////////////////////
   // this.cgiReadOnly = true;


   ////////////////////////////////////////////////////////////////
   //  LOCAL SCOPE MODE
   //  Defines how the local scope of a function is invoked when a variable with no scope definition is used.
   //  - modern: the local scope is always invoked
   //  - classic: CFML default,  the local scope is only invoked when the key already exists in it
   ////////////////////////////////////////////////////////////////
   // this.localMode = "classic"; 


   ////////////////////////////////////////////////////////////////
   //  CASCADING  
   //  Depending on this setting Lucee scans certain scopes to find a 
   //  variable called from the CFML source. This will only happen when the 
   //  variable is called without a scope. (Example: #myVar# instead of #variables.myVar#)
   //  - strict: scans only the variables scope
   //  - small: scans the scopes variables,url,form
   //  - standard: CFML Standard, scans the scopes variables,cgi,url,form,cookie
   ////////////////////////////////////////////////////////////////
   // this.scopeCascading = "standard";


   ////////////////////////////////////////////////////////////////
   //  SEARCH RESULTSETS  
   //  When a variable has no scope defined (Example: #myVar# instead of #variables.myVar#), 
   //  Lucee will also search available resultsets (CFML Standard) or not
   ////////////////////////////////////////////////////////////////
   // this.searchResults = true;
  

   ////////////////////////////////////////////////////////////////
   //  REQUEST: TIMEOUT
   //  Sets the amount of time the engine will wait
   //  for a request to finish before a request timeout will 
   //  be raised. This means that the execution of the request 
   //  will be stopped. This setting can be overridden using the 
   //  "cfsetting" tag or script equivalent.
   ////////////////////////////////////////////////////////////////
   // this.requestTimeout=createTimeSpan(0,0,0,50); 
   
 
   ////////////////////////////////////////////////////////////////
   //  COMPRESSION  
   //  Enable compression (GZip) for the Lucee Response stream 
   //  for text-based responses when supported by the client (Web Browser)
   ////////////////////////////////////////////////////////////////
   // this.compression = false;


   ////////////////////////////////////////////////////////////////
   //  SUPPRESS CONTENT FOR CFC REMOTING 
   //  Suppress content written to response stream when a 
   //  Component is invoked remote
   ////////////////////////////////////////////////////////////////
   // this.suppressRemoteComponentContent = false;
  

   ////////////////////////////////////////////////////////////////
   //  BUFFER TAG BODY OUTPUT 
   //  If true - the output written to the body of the tag is 
   //  buffered and is also outputted in case of an exception. Otherwise
   //  the content to body is ignored and not displayed when a failure
   //  occurs in the body of the tag.
   ////////////////////////////////////////////////////////////////
   // this.bufferOutput = false; 
  

   ////////////////////////////////////////////////////////////////
   //  UDF TYPE CHECKING 
   //  Enables/disables type checking of definitions with 
   //  function arguments and return values
   ////////////////////////////////////////////////////////////////
   // this.typeChecking = true;


   ////////////////////////////////////////////////////////////////
   //  QUERY CHACHEDAFTER
   //  Global caching lifespan for queries. This value is overridden when
   //  a tag "query" has the attribute "cachedwithin" defined.
   ////////////////////////////////////////////////////////////////
   // this.query.cachedAfter = createTimeSpan(0,0,0,0);

   

   ////////////////////////////////////////////////////////////////
   //  REGEX 
   //  Defines the regular expression dialect to be used.
   //  - modern: Modern type is the dialect used by Java itself.
   //  - classic CFML default, the classic CFML traditional type Perl5 dialect
   ////////////////////////////////////////////////////////////////
   // this.regex.type = "perl";



   ////////////////////////////////////////////////////////////////
   //  IMPLICIT NOTATION
   //  If there is no accessible data member (property, element of the this scope) 
   //  inside a component, Lucee searches for available matching "getters" or 
   //  "setters" for the requested property. The following example should 
   //  clarify this behaviour. "somevar = myComponent.properyName". 
   //  If "myComponent" has no accessible data member named "propertyName", 
   //  Lucee searches for a function member (method) named "getPropertyName".
   ////////////////////////////////////////////////////////////////
   // this.invokeImplicitAccessor = false;


   ////////////////////////////////////////////////////////////////
   //  ANTI-XXE CONFIGURATION
   //  XML External Entity attack is a type of attack against
   //  an application that parses XML input. This configuration enable/disable
   //  protection by XXE attack. It's enabled by default from 5.4.2 and 6.0.
   //  https://owasp.org/www-community/vulnerabilities/XML_External_Entity_(XXE)_Processing
   ////////////////////////////////////////////////////////////////
   // this.xmlFeatures = {
   //	  externalGeneralEntities: false,
   //	  secure: true,
   //	  disallowDoctypeDecl: false
   // };

   ////////////////////////////////////////////////////////////////
   //  MAIL SERVERS 
   //  defines one or more mail server connections. 
   //  When sending an email, Lucee tries to send the mail with the first 
   //  defined mail server. If the send operation fails, Lucee will 
   //  continue using the next mail server in the list.
   ////////////////////////////////////////////////////////////////
   // this.mailservers =[
   //     {
   //         host: "smtp.somesmtp.org"
   //        ,port: 587
   //        ,username: "email@somedomain.org"
   //        ,password: "mypassword"
   //        ,ssl: false
   //        ,tls: true
   //        ,lifeTimespan: CreateTimeSpan( 0, 0, 1, 0 )
   //        ,idleTimespan: CreateTimeSpan( 0, 0, 0, 10 )
   //    } 
   // ];



   ////////////////////////////////////////////////////////////////
   //  DATASOURCES
   //  Defines datasources by datasource name. These can be addressed by 
   //  by the "datasource" attribute of a "query" tag.
   ////////////////////////////////////////////////////////////////
   // 
   //  this.datasources["myDsnName"] = {
   //         class: 'com.mysql.cj.jdbc.Driver'
   //     , bundleName: 'com.mysql.cj'
   //     , bundleVersion: '8.0.19'
   //     , connectionString: 'jdbc:mysql://localhost:3306/test?characterEncoding=UTF-8&serverTimezone=Europe/Berlin&maxReconnects=3'
   //     , username: 'root'
   //     , password: "encrypted:..."

   //     // optional settings
   //     , connectionLimit:100 // default:-1
   //     , liveTimeout:60 // default: -1; unit: minutes
   //     , alwaysSetTimeout:true // default: false
   //     , validate:false // default: false
   // };

  



   ////////////////////////////////////////////////////////////////
   //  CACHES
   ////////////////////////////////////////////////////////////////
   //  this.cache.connections["myCache"] = {
   //     class: 'lucee.runtime.cache.ram.RamCache'
   //   , storage: false
   //   , custom: {"timeToIdleSeconds":"0","timeToLiveSeconds":"0"}
   //   , default: ''
   // };




   ////////////////////////////////////////////////////////////////
   //  MAPPINGS   
   ////////////////////////////////////////////////////////////////
   //
   // this.mappings["/lucee/admin"]={
   //         physical:"{lucee-config}/context/admin"
   //         ,archive:"{lucee-config}/context/lucee-admin.lar"
   // };
   //
   // this.mappings["/lucee/doc"]={
   //         archive:"{lucee-config}/context/lucee-doc.lar"
   // };





    /**
    * @hint First function run when Lucee receives the first request. 
    */
    public boolean function OnApplicationStart(){

        return true;
    
    }




    /**
    * @hint onApplicationEnd() is triggered when the application context ends, means when the 
    * timeout of the application context is reached (this.applicationTimeout). 
    */
    public void function onApplicationEnd( struct application ){

        return;

    }



    /**
    * @hint onSessionStart() is triggered with every request that has no session 
    * defined in the current application context. 
    */
    public void function onSessionStart(){

        return;

    }

    /**
    * @hint onSessionEnd() is triggered when a specific session context ends, 
    * when the timeout of a session context is reached (this.sessionTimeout). 
    */
    public void function onSessionEnd( struct session, struct application ){

        return;

    }


    /**
    * @hint onRequestStart() is triggered before every request, so you can 
    * prepare the environment for the request, for example to produce the HTML 
    * header or load some data/objects used within the request. 
    */
    public boolean function onRequestStart( string targetPage ){

        return true;

    }



    /**
    * @hint onRequest() is triggered during a request right after onRequestStart() ends and before 
    * onRequestEnd() starts. Unlike other CFML engines, Lucee executes this function without looking 
    * for the "targetPage" defined, while other CFML engines will complain if the targetPage doesn't 
    * physically exist (even if not used in the onRequest() function) 
    */
    public void function onRequest( string targetPage ){

        include arguments.targetPage;
        return;

    }


    /**
    * @hint onRequest() is triggered at the end of a request, right after onRequest() finishes. 
    */
    public void function onRequestEnd(){
    
        return;
    
    }



    /**
    * @hint onCFCRequest() is triggered during a request for a .cfc component, typically
    * used to handle remote component calls (e.g. HTTP Webservices). 
    */
    public void function onCFCRequest( string cfcName, string methodName, struct args ){
    
        return;

    }



    /**
    * @hint onError() is triggered when an uncaught exception occurs in this application context. 
    */
    public void function onError( struct exception, string eventname ){

        return;

    }




    /**
    * @hint OnAbort() is triggered when a request is ended with help of the "abort" tag. 
    */
    public void function  onAbort( string targetPage ){

        return;

    }


    /**
    * @hint onDebug() is triggered when debugging is enabled for this request.
    */
    public void function onDebug( struct debuggingData ){

        return;

    }


    /**
    * @hint onMissingTemplate() is triggered when the requested page wasn't found and no "onRequest()" 
    * function is defined.
    */
    public void function onMissingTemplate( string targetPage ){

        return;

    }


}
```
