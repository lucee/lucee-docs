---
title: ReST Services:Introduction
id: rest-services-introduction
---

### ReST Services ###

Lucee Server gives you the ability to define ReST Services (Representation State Transfer). ReST is and application architecture which defined stateless data transfer over networked services. In the context of the web ReST is commonly implemented over HTTP as it is a ReSTful protocol.

### Lucee and ReST ###

Lucee gives you the ability to define ReST services as a collection of CFC components by using a set of ReST specific attributes; and then telling Lucee what ReST path should be used to access the service. These services can be registered in the server admin, web admin or in the application CFC.

* Setting up a new Service
	* Server Admin & Web Admin
	* Application.cfc
* Building a ReST Service
	* Design & Architecture
	* Writing a ReST Component
	* Writing a ReST Function

### References: ###

* CFcomponent:
	* rest
	* restpath
	* httpmethod
* CFfunction:
	* access='remote'
	* restpath
	* httpmethod
	* produces
	* consumes
* CFargument
	* restargname
	* restargsource