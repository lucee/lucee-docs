---
title: Mongodb
id: extension-mongodb
---

## MongoDB Cache Provider Extension ##

The Lucee Server Mongo Cache Provider Extension allows you to use MongoDB as a key/value cache for your Objects (components), Templates, Queries and Resources (such as files etc).

MongoDB is an open source, scalable, high-performance, schema-free, document-oriented database written in the C++ programming language. You can find out more information and download it from [http://www.mongodb.org/](http://www.mongodb.org/)

### Installation ###

These instructions are geared towards the beta version currently

Installing the MongoDB Cache Extension, is fairly straight forward.

1. Go to the server administrator of your lucee installation, for example: http://localhost/lucee/admin/server.cfm

1. Under Extension/Applications you should see that under the "Not Installed" extensions there is "Mongo DB Cache"

1. Select the "MongoDb Cache" radio button and click the "Install" Button.

1. In the next screen, you will get (currently) a blank screen with an "Install" button, click this button.

1. You will get a "MongoDBCache is now successfully installed" message

### Running MongoDB ###

We need to have a running MongoDB installation to connect to. This section will let guide you through getting MongoDB running.

1. Head to the MongoDB website and select downloads http://www.mongodb.org/downloads

1. Download the right version for your Operating System (the screenshots here are for OS X but you can just follow the instructions included in the zip file for your operating system)

1. Unzip the file you downloaded, and place it somewhere useful (in this case we put it in Applications/mongodb)

You can follow the MongoDB QuickStart for your specific Operating System at http://www.mongodb.org/display/DOCS/Quickstart

1. Create a directory in the root called /data/db through the terminal:

	$ mkdir -p /data/db

1. In the terminal now head to the MongoDB install directory and start the server

	$ sudo /Applications/mongodb/bin/mongod

1. Now you have MongoDB running you should get a screen like:

### Creating a cache connection ###

1. In the Lucee Administrator, Go to Services/Cache and define a new cache connection, by giving it a name "mongo_test" and selecting the "MongoDBCache" type

1. In the next screen, define the Server Host (default localhost:27017 if you are installing the database locally), the Database "mongo_test" and finally enter the Collection name "mongo_test"

1. You can set it as the default cache for various functions, in this example you can set it as the default Object cache.

1. Finally, click "Submit" to save the connection

### Max Connection per Host ###

This define how many simultaneous connections will be allowed. While this value can be increased if you run in a very intense system use this setting with care.

### Authentication ###

To be able to authenticate with the provided credentials the 'admin' database over the mongodb machine must have this user setted up. Refer to guide [http://www.mongodb.org/display/DOCS/Security+and+Authentication](http://www.mongodb.org/display/DOCS/Security+and+Authentication) guide. I strongly recommend ( following mongoDB docs ) that you manage the authentication to your mongoDB server restricting the access to the machine in place of using the basic mongoDB authentication system.

### Persist over server restart ###

This says to your cache if it has to drop the all the data stored when you restart your server. If you are running mongoDB using Replica Sets ( cluster of many mongoDB instances ) set this to NO cause restarting a single server should drop the whole data replicated in the cluster.

### Replica Sets ###

MongoDB support a replication mode of the data over a cluster called Replica Sets: [http://www.mongodb.org/display/DOCS/Replica+Sets](http://www.mongodb.org/display/DOCS/Replica+Sets) . Here is where MongoDB really shines cause the replication is really effective and the automatic failover is running great. To allow your cache to use the whole Replica Sets add all the host that join the Sets into the hosts textarea ( one for line ). If a node in the sets goes down the cache will wait that a new master is elected and will go serving your data.

Run MongoDB using the replication is strongly recommended. Visit this page for more info about durability: [http://www.mongodb.org/display/DOCS/Durability+and+Repair](http://www.mongodb.org/display/DOCS/Replica+Sets)
