---
title: Create a Application.cfc
id: cookbook-application-context-basic
---

# Application.cfc #
The Application.cfc is a component you put in your web application that then is picked up by Lucee as part of the request.
The Application.cfc is used to define context specific configurations/settings and event driven functions.
Your website can have multiple Application.cfc files, every single file then defines a independent application context.

Let's say you have a website that has a shop under the path "/shop" that needs users sessions, but the rest of the website does not.
In that case you could define a Application.cfc at "/shop" that has session handling enabled and one in the webroot that has not.

## Location, Location, Location ##
With the default setting Lucee is always picking the "nearest" Application.cfc, so it is searching from the current location down to the webroot.
This is only one possible behavior of many, Lucee gives you the possibility in the Lucee Administartor under "Settings / Request" to decide where Lucee looks for the Application.cfc and if it looks at all.

![search mode](https://bitbucket.org/repo/rX87Rq/images/3223743265-APP-SEARCH-MODE.png)

So if you for example only have one Application.cfc in the webroot, define "Root" as setting.

## Functions ##
The Application.cfc is supporting multiple event driven functions, what does this means?
You can define functions inside the Application.cfc that are called when certain events are happening, this way you can participate with this events.

### OnApplicationStart ###
This function is triggered when no application context is existing for this Application.cfc, so normally with the first request on this application context.

```
component {
   boolean function onApplicationStart() {
      application.whatever=new Whatever(); // init whatever
   }
}
```
This is normally used to initialize the environment for your application, so for example load data/objects and store them in the application scope.
if the the function is returning false or throws a exception the application context is not initialized and the next request will call "onApplicationStart" again. "onApplicationStart" is thread safe.


### OnApplicationEnd ###
The opposite from "onApplicationStart", this function is triggered when the application context ends, means when the timeout of the application context is reached (this.applicationTimeout).

```
component {
   void function onApplicationEnd(struct application) {
      arguments.application.whatever.finalize();
   }
}
```
This is normally used to finalize the environment of your application, so for example unload data/objects.
You get the application scope that ends as argument with the function.


### OnSessionStart ###
This function is triggered with every request that has no session definedin the current application context

```
component {
   void function onSessionStart() {
      session.whatever=new Whatever(session.cfid); // init whatever
   }
}
```
This is normally used to initialize the environment for a specific session, so for example load data/objects and store them in the session scope.

### OnSessionEnd ###
The opposite from "onSessionStart", this function is triggered when a specific session context ends, means when the timeout of a session context is reached (this.sessionTimeout).

```
component {
   void function onSessionEnd(struct session,struct application) {
      arguments.session.whatever.finalize();
   }
}
```
This is normally used to finalize the environment of your application, so for example unload data/objects.
 You get the related application scope and the session scope that ends, as arguments with the function.


### OnRequestStart ###
This function is triggered before every request, so you can prepare the environment for the request, for example produce the HTML header or loads some data/objects used within the request.

```
component {
   boolean function onRequestStart(string targetPage) {
       echo('<html><head/><body>'); // outputs the response html header
       request.whatever=new Whatever(); // prepare a object to use within the request
       return true;
   }
}
```
if the the function is returning false Lucee stops any further execution of this request and return the result to the client.


### OnRequestEnd ###
This function is triggered after every request, so you can cleanup the environment after the request, for example produce the HTML footer or unload some data/objects used within the request.

```
component {
   void function onRequestEnd(string targetPage) {
       echo('</body></html>'); // outputs the response html footer
       request.whatever.finalize();
   }
}
```


### OnRequest ###
If this function exists, Lucee is only executing this function and no longer looks for the "targetPage" defined with the request.
So let's say you have the call "/index.cfm", if there is a "/index.cfm" in the file system or not, does not matter, it is not executed anyway.

**Other CFML Engines will complain when the called target page does not exists physically even it is never used!**

```
component {
   void function onRequest(string targetPage) {
       echo('<html><bod>Hello World</body></html>');
   }
}
```


### OnCFCRequest ###
Similar to "onRequest", but this function is used to handle remote component calls (HTTP Webservices).
```
component {
   void function onCFCRequest(string cfcName, string methodName, struct args) {
       echo('<html><bod>Hello World</body></html>');
   }
}
```

### OnError ###
This method is triggered when a uncaught exception occurs in this application context.

```
component {
   void function onError(struct exception, string eventName) {
       dump(var:exception,label:eventName);
   }
}
```
As arguments you get the exception (cfcatch block) and the eventName.

### OnAbort ###
This method is triggered when a request is ended with help of the tag <cfabort>.

```
component {
   void function onAbort(string targetPage) {
       dump("request "&targetPage&" ended with a abort!");
   }
}
```

### OnDebug ###
This method is triggered when debugging is enabled for this request.

```
component {
   void function onDebug(struct debuggingData) {
       dump(var:debuggingData,label:"debug information");
   }
}
```

### OnMissingTemplate ###
This method is triggered when a requested page was not found and **no function "onRequest" is defined **.


```
component {
   void function onMissingTemplate(string targetPage) {
       echo("missing:"&targetPage);
   }
}
```
