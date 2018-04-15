---
title: ORM:first_example
id: orm-first-example
categories:
- orm
---

## First example ##

Let's have a look at a simple example where we want to persist a certain CFC to a MySQL database. Further below all necessary steps in order to get ORM to work with Lucee are described. We will assume the following scenario: We have an easy blog where an author can submit his blog post containing the following properties for an entry:

* author
* publish date
* title
* teaser
* text
* tags

Nothing more for the moment. So let's start by creating the necessary CFC that will hold the information about a blog entry:

```lucee
<cfcomponent persistent="true">
	<cfproperty name="entryID" generator="increment">
	<cfproperty name="author">
	<cfproperty name="publishDate">
	<cfproperty name="title">
	<cfproperty name="teaser">
	<cfproperty name="text">
	<cfproperty name="tags">
</cfcomponent>
```

There are many more <cfcomponent></cfcomponent> attributes that we need to address as well, but for now this is quite sufficient. Next step to do is to create a MySQL table that will map to this CFC. (There is an autocreate functionality that automatically creates your tables, but we will describe that later).

So let's create the table with the following statement:
