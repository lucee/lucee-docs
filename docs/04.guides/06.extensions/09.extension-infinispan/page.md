---
title: Infinispan Cache Extension
id: extension-infinispan
menuTitle: Infinispan
---

The [Infinispan](http://www.jboss.org/infinispan) extension allows you to create Infinispan caches, and access remote caches via the Hot Rod Protocol (which is compatible with Java, Python, PHP, Ruby, etc. as well).

### Installation ###

1. Go to the server administrator of your lucee installation, for example: <http://localhost/lucee/admin/server.cfm>

1. Under Extension/Applications you should see that under the "Not Installed" extensions there is

1. Select "Infinispan Cache" and click the "Install" Button.

1. In the next screen, you will get (currently) a blank screen with an "Install" button, click this button.

1. You will get a "Infinispan Cache is now successfully installed" message.

### Running Infinispan ###

You can connect to remote Infinispan clusters via the Hot Rod protocol. "Remote" meaning caches outside the same JVM as your Lucee application-- maybe "outside" on the same machine, maybe spread across 10 other machines.

To run an Infinispan instance with the Hot Rod protocol enabled, download Infinispan, create a test config with at least one named cache, and start infinispan using the test config and with the "-r hotrod" command line option.

./infinispan/bin/startServer.sh -r hotrod -c ./infinispan-hotrod-cfg.xml -l 127.0.0.1

### Defining Cache Connections ###

**Connecting via Hot Rod:**

In the Lucee Administrator, Go to Services/Cache and define a new cache connection, using the name of one of the caches defined in your infinispan config file, and selecting the "Infinispan Hot Rod Client Cache" type.

The cache *must* be defined in the infinispan config prior to trying to connect to it from Lucee. As of this writing (Infinispan 5.0.1), asymmetric caches are not supported, meaning all instances in the cluster must have the same caches defined, and cache creation at runtime is not supported (you cannot have 5 caches on one instance and 4 on another and expect replication or distribution to work).

You can leave the Hot Rod settings at their defaults, as infinispan will be listening on 127.0.0.1:11222 if you started it using the parameters above.

If you want to use this cache as a default cache type (otherwise you will have to specify the cache name for all operations-- a best practice, but not required if you've set default caches).

Verify the cache connection. If it cannot connect, verify that infinispan is running with Hot Rod enabled on the default port (11222).

### Create a Cache ###

In the Lucee Administrator, Go to Services/Cache and define a new cache connection, selecting the "Infinispan Cache" type.

If you want to use this cache for session/client storage, check the box, and then enter the path to your infinispan configuration file. We will add some options that you can define from the Lucee Admin, but Infinispan is *highly* configurable, and exposing all the options in a sane manner will take some time.

### Using the cache ###

Create a page under your webroot called cachetest.cfm

Add the following code to cachetest.cfm to allow you to test the connection

```lucee
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
