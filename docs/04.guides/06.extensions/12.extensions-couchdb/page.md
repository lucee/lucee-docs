---
title: Couchdb
id: extension-couchdb
---

## CouchDB Cache Provider Extension ##

The Lucee Server CouchDB Cache Provider Extension allows you to use CouchDB as a key/value cache for your Objects (components), Templates, Queries and Resources (such as files etc).

CouchDB is a free and open source document-oriented database written in the Erlang programming language. You can find out more information either download or setup your own database at CouchOne.

### Installation ###

Installing the CouchDB Cache Extension, is straight forward.

1. Go to the server administrator of your lucee installation, for example: http://localhost/lucee/admin/server.cfm 

1. Under Extension/Applications you should see that under the "Not Installed" extensions there is "CouchDB Cache ( Beta )".

1. Select the "CouchDB Cache (Beta)" radio button and click the "Install" Button.

1. In the next screen, you will get (currently) a blank screen with an "Install" button, click this button.

1. You will get a "CouchDBCache is now successfully installed" message.

### Running CouchDB ###

We need to have a running CouchDB installation to connect to, this section will let guide you through getting CouchDB running

1. Head to the CouchOne website and select products http://www.couch.io/products.

1. Download the right version for your Operating System (the screenshots here are for OS X but there should be no difference for each OS).

1. Once downloaded, run CouchDB and you should get the following view:

1. Create a new database called "lucee_cache", this is the database that we are going to use as our cache.

### Creating a cache connection ###

1. In the Lucee Administrator, Go to Services/Cache and define a new cache connection, by giving it a name "cache_test" and selecting the "CouchDB" type.

1. In the next screen, define the Server Host (default localhost if you are installing the database locally), the Server Port (defaults to 5984) and finally enter the Database name that we created on the CouchDB server: "lucee_cache".

1. You can set it as the default cache for various functions, in this example you can set it as the default Object cache.

1. Finally, click "Submit" to save the connection

1. You should verify the connection works, by ticking the checkbox next to the "cache_test" connection and clicking the verify button.

1. You are now all set to use the connection!.

### Using the Cache ###

1. Create a page under your webroot called cachetest.cfm

1. In the cachetest.cfm you add the following code to test the connection:

```lucee
<h1>Cache Test</h1>
<cfscript>
 stItem = {
  name: "Elvis",
  age: "36"
};

dump(var=stItem, label="Sending to Cache");
cachePut("myElvis",stItem);
dump(var=cacheGet("myElvis"), label="From Cache");
</cfscript>
```

This code essentially creates a struct called "stItem", we then dump the item, put it in the cache, and retrieve it

When you run this code, you will get something that looks like:

Troubleshooting

If you get an error along the lines of:


```lucee
java.lang.NoClassDefFoundError: org/slf4j/spi/LoggerFactoryBinder
	at java.lang.ClassLoader.defineClass1(Native Method)
	at java.lang.ClassLoader.defineClassCond(ClassLoader.java:632)
	at java.lang.ClassLoader.defineClass(ClassLoader.java:616)
	at java.lang.ClassLoader.defineClass(ClassLoader.java:466)
```

You should download the slf4j api and slf4j log4j libraries and place them in your lib/ folder of your Lucee installation (for example if you are using Apache Tomcat, you should place it in <tomcat></tomcat>/lib folder)
