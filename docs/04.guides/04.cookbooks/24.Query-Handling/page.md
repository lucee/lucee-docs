---
title: Query Handling In Lucee
id: query-handling-lucee
related:
- tag-query
- tag-queryparam
- function-queryexecute
categories:
- query
description: How to do SQL Queries with Lucee
---

This document explains how SQL queries are supported in Lucee.

## Query tags ##

[[tag-query]] different ways to use the tags in Lucee and how we can the pass the value into the query

```lucee
<cfquery name="qry" datasource="test">
	select * from Foo1890
</cfquery>
<cfdump var="#qry#" expand="false">
```

The above example just shows how to retrieve the data from the database.


### Using QueryParam ###

The [[tag-QueryParam]] is used inside the [[tag-query]] tag. It is used to bind the value with the SQL statement.

```lucee
<cfquery name="qry" datasource="test">
	select * from Foo1890
	where title=<cfqueryparam sqltype="varchar" value="Susi">
</cfquery>
<cfdump var="#qry#" expand="false">
```

Passing values with [[tag-QueryParam]] has two advantages:

* The value you pass in QueryParam is very secure,
* Lucee is able to cache the query statement and reuse it as long as the value is unchanged.

### params ###
Here we use param as part of cfquery tag, used to pass the value with SQL statement.

Pass the params value with struct

```lucee
<cfquery name="qry" datasource="test" params="#{title:'Susi'}#">
	select * from Foo1890
	where title=:title
</cfquery>
<cfdump var="#qry#" expand="false">
```

referenced as ```:key``` in sql.

The below example shows how to pass more information using a struct.

```lucee
<cfquery name="qry" datasource="test" params="#{title:{type:'varchar',value:'Susi'}}#">
	select * from Foo1890
	where title=:title
</cfquery>
<cfdump var="#qry#" expand="false">
```

You can pass the params value using an array. It is referenced as '?' in SQL.

```lucee
<cfquery name="qry" datasource="test" params="#['Susi']#">
	select * from Foo1890
	where title=?
</cfquery>
<cfdump var="#qry#" expand="false">
```

The below example shows how to pass more information using an array.

```lucee
<cfquery name="qry" datasource="test" params="#[{type:'varchar',value:'Susi'}]#">
	select * from Foo1890
	where title=?
</cfquery>
```

## Query with script tag ##

Lucee supports two types of script statements as shown below:

```lucee
<cfscript>
query name="qry" datasource="test" params={title:{type:'varchar',value:'Susi'}} {
	echo("
		select * from Foo1890
		where title=:title
	");
}
dump(qry);
</cfscript>
```

```lucee
<cfscript>
cfquery(name="qry",datasource="test",params={title:{type:'varchar',value:'Susi'}}) {
	echo("
		select * from Foo1890
		where title=:title
	");
}
dump(qry);
</cfscript>
```

## QueryExecute ##

Lucee includes support for [[function-QueryExecute]] via script or tag. You can pass all the arguments to the function.

```lucee
<cfscript>
qry=queryExecute(
	sql:"select * from Foo1890 where title=:title"
	,options:{datasource="test"}
	,params={title:{type:'varchar',value:'Susi'}}
);
dump(qry);
</cfscript>
```

Pass the values in params same as we saw in cfquerytag, In options we can pass other arguments like datasource,cachename,dbtype



### Query Component ###

You can do a query with component like "Query()".

```lucee
<cfscript>
	query=new Query(sql:"select * from Foo1890 where title=?");
	query.setParams([{type:'varchar',value:'Susi'}]);
	query.setDatasource('test');
	dump(query.execute().getResult());
</cfscript>
```

In the above example we pass the sql as part of the constructor.

* Use setDatasource() function to set the datasource.
* Use setParams() function to set the param values. The value used is the same as we used in the tag.

```query.execute()``` function returns detail of the component, ```query.execute().getResult()``` returns query result.

### Query Future ###
We are always in discussion how to improve the functions in lucee.

This output technique ```$("Hi there")``` can be used anywhere in the file (not just inside a query).

```lucee
<cfscript>
query name="qry" datasource="test" params={title:{type:'varchar',value:'Susi'}} {
	$("
		select * from Foo1890
		where title=:title
	");
}
dump(qry);
</cfscript>
```

We can use not only for query, you can use any where in the file ```$("Hi there")``` make our output. This idea to make a code better

Lucee also supports static functions as shown in the example code below:

```lucee
<cfscript>
// Component gets more static functions
q=Query::new("a,b,c");	// equal to queryNew("a,b,c"), already exists
Query::execute(...);	// equal to queryExecute(), coming soon
</cfscript>
```
### Query Builder ###

Query Builder use as extension, it will not come up with core.

It is much easier to do a simple query.

You can

```lucee
<cfscript>
// Query Builder (creates SQL in dialect based on the datasource defined)
	qb=new QueryBuilder("test")
		.select("lastName")
		.from("person")
		.where(QB::eq("firstname","Susi"));
	qb.execute();
	dump(res);
</cfscript>
```
Use ```QueryBuilder("test")``` as constructor

* define a datasource with constructor or 'setDatasource('test')' function,
* Use ```select("lastName")``` to select the column
* Use ```from("person")``` from which table you want to retrieve data,
* where statement like ```where(QB::eq("firstname","Susi"))```,

Use ```qb.execute()``` to obtain the result.

You can change selected column like below example

```lucee
<cfscript>
// change select
qb.select(["age","firstname"]);
qb.execute();
dump(res);
</cfscript>
```
You can also change the where condition also like below example

```lucee
<cfscript>
// change where
qb.clear("where");
qb.where(
	QB::and(
		QB::eq("firstname","Susi"),
		QB::neq("lastname","Moser"),
		QB::lt("age",18)
	)
);
qb.execute();
dump(res);
</cfscript>
```

### Footnotes ###

Here you can see above details in video

<https://www.youtube.com/watch?time_continue=684&v=IMdPM58guUQ>
