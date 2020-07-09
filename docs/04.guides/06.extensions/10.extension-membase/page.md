---
title: Membase
id: extension-membase
---

### Membase Cache Provider Extension ###

The Lucee Server Membase Cache Provider Extension allows you to use Membase as a key/value cache for your Objects (components), Templates, Queries and Resources (such as files etc).

NorthScale Membase Server is an elastic key-value database that stores web application data far more efficiently and cost effectively than it can be stored in a relational database. With NorthScale Membase Server, organizations can deploy a highly available, cloud-friendly data layer that expands dynamically as application needs change, delivering performance exceeding that of any other NoSQL solution. API compatible with memcached, the de facto standard web caching software, Membase is easy to use and supported by virtually every programming language and application framework.

Installation

Installing the Membase Cache Extension, is fairly straight forward.

1. Go to the server administrator of your lucee installation, for example: <http://localhost/lucee/admin/server.cfm>

1. Under Extensions/Providers make sure that [http://preview.lucee.org/ExtensionProvider.cfc](http://preview.lucee.org/ExtensionProvider.cfc) exists in your providers list. If not add and verify it.

1. Under Extension/Applications you should see that under the "Not Installed" extensions there is "Membase Cache"

1. Select the "Membase Cache" radio button and click the "Install" Button. Follow the installation process up to when you will get a "Membase Cache is now successfully installed" message.

### Install Membase ###

Refer to the this page for instructions about installing membase on your specific OS.

* Build membase and dependencies
* Download binaries

If you run MacOsx exists a homebrew formula updated to install version 1.6 beta 3.

Creating a cache connection

1. In Services/Cache create a new instance of Membase Cache. You can also select if you need to use this instance as default for objects/templates/queries/resources.

1. Fill in the required information for creating a connection to your membase server ( or cluster ).

What is MOXI ??

As you can see from the previous pic the cache connection asks you to provide a single host/port connection details. This is true even if you will use several membase servers in a cluster.

**Moxi is the proxy that membase uses to interface to memcached instances**. While the membase guys improve the java client you will need to use moxi to allow your application to use the whole cluster. This solution is also optimal for performance reason. Basically your local moxi will route any request from the application to the most appropriate cluster node. Your client will no need to call a remote server, wait for the answer and, in case, try to connect a different node.

Install a standalone Moxi instance on the same client where your Lucee server is running. Your lucee server will only know this single moxi host and will always invoke this service. When you start your moxi service you will declare the location of any node making part of the cluster:

```lucee
moxi http://{membase server1}:8080/pools/default/bucketsStreaming/default http://{membase server2}:8080/pools/default/bucketsStreaming/default
```

As you see moxi will try to use the 2 passed hosts as part of the cluster and will manage the routing of your application calls. **Important : you will need in any case to access the membase administration panel ( on both hosts ) and to add them into the same cluster**. When this is done you will start using the power of memcached with the agility of membase.

If you run a single membase server on you localhost for testing purposes, you will not need to launch moxi manually cause the server will already do that . Just point your cache to the moxi host using the default port.

* Memcached is designed to manage very large sets of data in a complex distributed environment. For this reason some operation like for example getting the list of the keys actually cached are not supported as could not be efficient. For this and similar reasons the following functions are not supported and will throw an exception if used on a Membase Cache instance:
	* cacheCount()
	* cacheGetAllIds()
	* cacheGetAll()

* The function cacheGetMetadata() will return metadata only for the whole cache instance but not for the single key.
Actually the java client allow us to manage the cache using the default bucket ( this is planned to be improved by the membase guys in a near future ).

* Actually the java client allow us to manage the cache using the default bucket ( this is planned to be improved by the membase guys in a near future ).
