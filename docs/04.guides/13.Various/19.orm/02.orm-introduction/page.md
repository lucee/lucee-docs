---
title: ORM:introduction
id: orm-intro
categories:
- orm
---

### ORM with Lucee ###

This section is going to describe how ORM (object relational mapping) is handled by Lucee 3.2 Server. Lucee Server uses Hibernate in the background for implementing ORM. If you want to learn more about Hibernate, just check the corresponding [documentation](http://www.hibernate.org/).


### What is ORM ? ###

According to Wikipedia ORM is: Object-relational mapping (ORM, O/RM, and O/R mapping) in computer software is a programming technique for converting data between incompatible type systems in object-oriented programming languages. This creates, in effect, a "virtual object database" that can be used from within the programming language. There are both free and commercial packages available that perform object-relational mapping, although some programmers opt to create their own ORM tools.. You can find the complete description of ORM on Wikipedia.

Basically ORM is a way to store your objects in a database automagically. In Lucee these objects of course are CFC components. So what we are trying to do is to save the data that is stored inside a CFC into a flat database table. This of course is not the only advantage one gets when using ORM. In my opinion the greatest benefit is the standardization of the storage mechanism across databases. Instead of writing lots of tags you will only have to call some procedures. So here the pros of ORM:

### Pros ###

* No need to deal with the SQL Queries to save and retrieve the data
* automatic checkings
* cross database coding possible
* DATABASE independency
* Simple configuration
* Standardized API to persist the business objects
* Fast development of application
* Concurrency support
* Excellent cashing support for better performance of the application
* Injected transaction management
* Configurable logging
* Easy to learn and use
* best suited for large projects

Of course using ORM has some disadvantages as well. So lets have a look at the cons of ORM:

### Cons ###

* performance worse than native queries
* not so flexible
* additional libraries
* lots of CFC instantiations
* bugs in ORM are severe
* Too much effort for small programs
* Poorer performance with large amount of data
* Takes more time to write small programs

So ORM is something you should consider as soon as you have to plan or design a new CFML project. This documentation will show you how ORM works with Lucee 3.2 and what you need to do in order to configure it. We will cover the different configuration options and the implications on the result.

In order to store CFC's in the database Lucee will introduce new object types called entities in the further context. Therefore the functions that handle these entities are called Entity*(). Like EntityLoad() or EntitySave() etc. In the future when we talk of CFCs that need to be saved to the database, we speak of persistent CFCs.
