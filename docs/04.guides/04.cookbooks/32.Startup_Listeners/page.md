---
title: Startup Listeners
id: Startup Listeners-code
---
## Startup Listeners Code ##

Lucee has two kinds of listeners. The first one is server.cfc that is called at server startup. It exists only once. The second listener is web.cfc which can exist for each web context on your server. We explain the two listeners with a simple example below:

####Example1:####

Create a test cfc file in lucee-server\context\context directory.  

```lucee

// lucee-server\context\context\server.cfc

	component{
		public function onServerStart(){
			systemOutput("--------------------------",true);
			systemOutput("-------server Context-----",true);
			systemOutput("--------------------------",true);
		}
	}
```

* Here, server.cfc has one function ``onServerStart()`` . It outputs three lines of content.
* Start the Lucee server ``Startup`` . Here the console shows the server context which means it triggered server.cfc
* Finally, stop Lucee.

####Example2:####

Create a test cfc file in webapps\ROOT\WEB-INF\lucee\context\ directory.  

```lucee

// webapps\ROOT\WEB-INF\lucee\context\web.cfc

component {
	public function onWebStart(reload){
		systemOutput("--------------------------",true);
		systemOutput--------web Context---------true);
		systemOutput("reload?"&reload,true);
		systemOutput("--------------------------",true);
	}
}
```

Here web.cfc has one function ``onWebStart()`` and one argument ``reload`` that indicates if the web context is a new startup of the server. Here ``reload`` is used to reload the web context. We see the difference when setting reload to true or false. 

* Start the Lucee server ``Startup`` . Here we see the server context first, then the web context is next. So both listeners get triggered by Lucee.
* Next, change the **settings --> charset** for web charset "UTF-8" in web admin.
* After setting the charset in web admin, the web context only is reloaded and we do not have the server context. So this feature is used to stop/prevent any difficulties with the server context.

This is a simple way to stop the server context. It is never triggered because there is no event happening inside java.

### Footnotes ###

Here you can see above details in video

[Lucee Startup Listeners](https://youtu.be/b1MWLwkKdLE)
