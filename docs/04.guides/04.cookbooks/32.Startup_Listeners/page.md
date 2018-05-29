---
title: Startup Listeners
id: Startup Listeners-code
---
## Startup Listeners Code ##

It have two kind of listeners. The first one is server.cfc that is called the server start, it exist at only once. Then second one is web.cfc that it can exists for every single web context on your server. We explain two listeners with a simple example below:

####Example1:####

Create a test cfc file in lucee-server\context\context directory.  
_// lucee-server\context\context\server.cfc_

```lucee
	component{
		public function onServerStart(){
			systemOutput("--------------------------",true);
			systemOutput("-------server Context-----",true);
			systemOutput("--------------------------",true);
		}
	}
```

* Here this server.cfc have one function ``onServerStart()``. It have three contents in output.
* Start the lucee server ``Startup``. Here the console have showing the server context, It means triggered the server.cfc
* Finally, stop the lucee.

####Example2:####

Create a test cfc file in webapps\ROOT\WEB-INF\lucee\context\ directory.  
_// webapps\ROOT\WEB-INF\lucee\context\web.cfc_

```lucee
component {
	public function onWebStart(reload){
		systemOutput("--------------------------",true);
		systemOutput--------web Context---------true);
		systemOutput("reload?"&reload,true);
		systemOutput("--------------------------",true);
	}
}
```

Here this web.cfc have one function ``onWebStart()`` and one argument ``reload`` that indicates if the web context is it's a new startup of the server. Here ``reload`` is used to reload the web context. we see the difference while setting reload is true or false. 

* Start the lucee server ``Startup``. Here we see the server context first then web context for next, So both listeners get triggered by lucee.
* Then Change the **settings --> charset** for web charset "UTF-8" in web admin.
* After setting that, web context only reloaded and don't have the server context. So this feature is used to stop any difficulties of server context. 

This way is simply stop the service and never triggered, because there is no event happening inside java. 

### Footnotes ###

Here you can see above details in video

[Lucee Startup Listeners](https://youtu.be/b1MWLwkKdLE)
